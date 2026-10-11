let catalog = [];
let character = null;
function persist() {
    sessionStorage.setItem('character', JSON.stringify(character));
}

document.addEventListener('DOMContentLoaded', init);

async function init() {
    const response = await fetch('/api/catalog');
    catalog = await response.json();

    character = JSON.parse(sessionStorage.getItem('character') || 'null');

    const content = document.getElementById('content');
    if (!character) {
        content.textContent = 'Персонаж не найден. Создайте нового.';
        return;
    }

    document.getElementById('change-composition').addEventListener('click', () => {
        sessionStorage.setItem('mode', 'edit');
        location.href = 'select.html';
    });

    render();
}

function render() {
    const content = document.getElementById('content');
    content.innerHTML = '';

    for (const block of catalog) {
        const shown = block.properties.filter(p => !p.isService && character.show[p.propKey]);
        if (shown.length === 0 && !block.isRoot) continue;

        const blockEl = document.createElement('section');
        blockEl.className = 'block';

        const head = document.createElement('div');
        head.className = 'block-head';

        const title = document.createElement('span');
        title.className = 'block-title';
        title.textContent = block.title;
        head.appendChild(title);

        // --- кнопка перегенерации блока ---
        const regen = document.createElement('button');
        regen.type = 'button';
        regen.className = 'regen';
        regen.title = 'Перегенерировать блок';
        regen.textContent = '🎲';
        regen.addEventListener('click', () => regenerateBlock(block));
        head.appendChild(regen);
        // ----------------------------------


        blockEl.appendChild(head);

        const propsEl = document.createElement('div');
        propsEl.className = 'props open';
        for (const prop of shown) propsEl.appendChild(renderProp(prop));

        blockEl.appendChild(propsEl);
        content.appendChild(blockEl);
    }
}

function renderProp(prop) {
    const row = document.createElement('div');
    row.className = 'prop-row';

    const name = document.createElement('span');
    name.className = 'prop-name';
    name.textContent = prop.title + ':';
    row.appendChild(name);

    const edited = Object.prototype.hasOwnProperty.call(character.fix, prop.propKey);
    const raw = edited ? character.fix[prop.propKey] : character.val[prop.propKey];

    const valueEl = document.createElement('span');
    valueEl.className = 'prop-value';
    valueEl.textContent = displayValue(prop, raw);
    valueEl.title = 'Двойной клик — изменить';
    valueEl.addEventListener('dblclick', () => startEdit(row, prop));
    if (edited) {
        const mark = document.createElement('span');
        mark.className = 'edited';
        mark.textContent = ' ✎';
        valueEl.appendChild(mark);
    }
    row.appendChild(valueEl);

    if (edited) {
        const revert = document.createElement('button');
        revert.type = 'button';
        revert.className = 'revert';
        revert.title = 'Вернуть сгенерированное';
        revert.textContent = '↺';
        revert.addEventListener('click', () => {
            delete character.fix[prop.propKey];
            render();
            persist();  // ← сохраняем в sessionStorage
        });
        row.appendChild(revert);
    }

    return row;
}

// для списка возвращаем текст по ключу; для computed/template — как есть
function valueText(prop, raw) {
    if (raw === undefined || raw === null || raw === '') return '';
    if (prop.valueType === 'list') {
        const found = prop.values.find(v => v.valKey === raw);
        return found ? found.text : raw;   // ручной текст показываем как есть
    }
    return raw;
}

function displayValue(prop, raw) {
    const text = valueText(prop, raw);
    if (!text) return '—';
    return prop.unit ? text + ' ' + prop.unit : text;
}

function startEdit(row, prop) {
    const valueEl = row.querySelector('.prop-value');
    const edited = Object.prototype.hasOwnProperty.call(character.fix, prop.propKey);
    const raw = edited ? character.fix[prop.propKey] : character.val[prop.propKey];

    const input = document.createElement('input');
    input.type = 'text';
    input.className = 'edit-input';
    input.value = valueText(prop, raw);

    valueEl.replaceWith(input);
    input.focus();
    input.select();

    const before = input.value;

    let finished = false;
    function finish(save) {
        if (finished) return;
        finished = true;

        if (save && input.value !== before) {
            character.fix[prop.propKey] = input.value;
        }

        render();
        persist();
    }

    input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') finish(true);
        else if (e.key === 'Escape') finish(false);
    });
    input.addEventListener('blur', () => finish(true));
}

function showDialog(text, buttons) {
    return new Promise((resolve) => {
        const modal = document.getElementById('modal');
        const textEl = document.getElementById('modal-text');
        const buttonsEl = document.getElementById('modal-buttons');

        textEl.textContent = text;
        buttonsEl.innerHTML = '';

        for (const b of buttons) {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.textContent = b.label;
            if (b.primary) btn.className = 'primary';
            btn.addEventListener('click', () => {
                modal.classList.add('hidden');
                resolve(b.value);
            });
            buttonsEl.appendChild(btn);
        }

        modal.classList.remove('hidden');
    });
}

async function applyGenerate(fix, show) {
    const response = await fetch('/api/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ fix, show })
    });
    character = await response.json();
    persist();
    render();
}

async function regenerateBlock(block) {
    // --- корневой блок: особый диалог ---
    if (block.isRoot) {
        const choice = await showDialog(
            `Перегенерация блока «${block.title}» меняет основу персонажа.`,
            [
                { label: 'Поменять всё', value: 'all', primary: true },
                { label: 'Оставить как есть', value: 'keep' },
                { label: 'Отмена', value: 'cancel' }
            ]);

        if (choice === 'cancel' || choice === null) return;

        if (choice === 'all') {
            // всё пересобрать, правки стереть -> связанный режим
            await applyGenerate({}, character.show);
            return;
        }

        // «Оставить как есть»: корни новые, всё остальное фиксируем как есть
        const coreKeys = new Set(block.properties.map(p => p.propKey));
        const newFix = { ...character.fix };
        for (const [k, v] of Object.entries(character.val)) {
            if (!coreKeys.has(k)) newFix[k] = character.fix[k] ?? v;
        }
        await applyGenerate(newFix, character.show);
        return;
    }

    // --- обычный блок ---
    const ownKeys = block.properties.map(p => p.propKey);
    const edited = ownKeys.filter(k => Object.prototype.hasOwnProperty.call(character.fix, k));

    if (edited.length > 0) {
        const ok = await showDialog(
            `В блоке «${block.title}» есть ручные правки (${edited.length}). При перегенерации они будут потеряны.`,
            [
                { label: 'Перегенерировать', value: 'yes', primary: true },
                { label: 'Отмена', value: 'no' }
            ]);
        if (ok !== 'yes') return;
    }

    const newFix = { ...character.fix };
    for (const k of ownKeys) delete newFix[k];

    const response = await fetch('/api/regenerate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            v: character.v,
            val: character.val,
            show: character.show,
            fix: newFix,
            block: block.blockKey
        })
    });

    character = await response.json();
    persist();
    render();
}