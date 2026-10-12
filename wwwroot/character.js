let catalog = [];
let character = null;
let dirty = false;
let slot = null;

document.addEventListener('DOMContentLoaded', init);

async function init() {
    const response = await fetch('/api/catalog');
    catalog = await response.json();

    character = decodeCharacterFromHash();
    if (!character) {
        location.replace('index.html');
        return;
    }

    slot = character.id ? findSlotById(character.id) : null;

    // конфликт: персонаж есть в коллекции, но ссылка другая
    if (slot && hashOf(location.href) !== hashOf(slot.url)) {
        const resolved = await resolveConflict();
        if (!resolved) return;   // отмена — уже ушли на главную
    }

    document.getElementById('create').addEventListener('click', createSlot);
    document.getElementById('update').addEventListener('click', updateSlot);
    document.getElementById('save-as-new').addEventListener('click', saveAsNew);
    document.getElementById('delete').addEventListener('click', deleteSlot);

    document.getElementById('panel-toggle').addEventListener('click', openPanel);
    document.getElementById('panel-apply').addEventListener('click', applyShow);
    document.getElementById('panel-cancel').addEventListener('click', closePanel);
    document.getElementById('panel-backdrop').addEventListener('click', closePanel);

    render();
    updateActions();
}

// ---------- рендер ----------

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

        const regen = document.createElement('button');
        regen.type = 'button';
        regen.className = 'regen';
        regen.title = 'Перегенерировать блок';
        regen.textContent = '🎲';
        regen.addEventListener('click', () => regenerateBlock(block));
        head.appendChild(regen);

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
    const raw = effective(character, prop.propKey);

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
            markDirty();
            render();
        });
        row.appendChild(revert);
    }

    return row;
}

function startEdit(row, prop) {
    const valueEl = row.querySelector('.prop-value');
    const raw = effective(character, prop.propKey);

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
            markDirty();
        }
        render();
    }

    input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') finish(true);
        else if (e.key === 'Escape') finish(false);
    });
    input.addEventListener('blur', () => finish(true));
}

// ---------- состояние кнопок ----------

function markDirty() {
    dirty = true;
    updateActions();
}

function updateActions() {
    const inGallery = !!slot;

    document.getElementById('create').classList.toggle('hidden', inGallery);
    document.getElementById('update').classList.toggle('hidden', !inGallery);
    document.getElementById('save-as-new').classList.toggle('hidden', !inGallery);
    document.getElementById('delete').classList.toggle('hidden', !inGallery);

    document.getElementById('update').disabled = !dirty;
}

// ---------- действия со слотами ----------

function persistToLink() {
    history.replaceState(null, '', buildCharacterLink(character));
}

function createSlot() {
    if (!character.id) character.id = newId();
    persistToLink();

    const item = {
        id: character.id,
        title: nextTitle(),
        date: new Date().toISOString(),
        url: location.href
    };

    const list = getGallery();
    list.push(item);
    saveGallery(list);

    slot = item;
    dirty = false;
    updateActions();
    showToast('Сохранено: ' + item.title);
}

function updateSlot() {
    if (!dirty) return;
    persistToLink();

    const list = getGallery();
    const item = list.find(x => x.id === character.id);
    if (item) {
        item.url = location.href;
        item.date = new Date().toISOString();
        saveGallery(list);
        slot = item;
    }

    dirty = false;
    updateActions();
    showToast('Персонаж обновлён');
}

function saveAsNew() {
    character.id = newId();
    persistToLink();

    const item = {
        id: character.id,
        title: nextTitle(),
        date: new Date().toISOString(),
        url: location.href
    };

    const list = getGallery();
    list.push(item);
    saveGallery(list);

    slot = item;
    dirty = false;
    updateActions();
    showToast('Сохранено как ' + item.title);
}

async function deleteSlot() {
    if (!(await showConfirm('Удалить этого персонажа из коллекции?'))) return;

    saveGallery(getGallery().filter(x => x.id !== character.id));
    slot = null;
    updateActions();
    showToast('Удалено из коллекции');
}

// ---------- перегенерация блоков ----------

async function applyGenerate(fix, show) {
    const response = await fetch('/api/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ fix, show })
    });
    const result = await response.json();
    character = { ...result, id: character.id };   // id слота сохраняем
    markDirty();
    render();
}

async function regenerateBlock(block) {
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
            await applyGenerate({}, character.show);
            return;
        }

        const coreKeys = new Set(block.properties.map(p => p.propKey));
        const newFix = { ...character.fix };
        for (const [k, v] of Object.entries(character.val)) {
            if (!coreKeys.has(k)) newFix[k] = character.fix[k] ?? v;
        }
        await applyGenerate(newFix, character.show);
        return;
    }

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
            id: character.id,
            val: character.val,
            show: character.show,
            fix: newFix,
            block: block.blockKey
        })
    });

    const result = await response.json();
    character = { ...result, id: character.id };
    markDirty();
    render();
}
// ---------- боковая панель «Показать» ----------

function openPanel() {
    const rootPanel = document.getElementById('panel-root');
    const otherPanel = document.getElementById('panel-other');
    rootPanel.innerHTML = '';
    otherPanel.innerHTML = '';

    renderPanelBlocks(rootPanel, catalog.filter(b => b.isRoot), true);
    renderPanelBlocks(otherPanel, catalog.filter(b => !b.isRoot), false);

    document.querySelectorAll('#panel-other .block').forEach(b => updatePanelBlockState(b));
    document.getElementById('panel-backdrop').classList.remove('hidden');
    document.getElementById('show-panel').classList.remove('hidden');
}

function closePanel() {
    document.getElementById('panel-backdrop').classList.add('hidden');
    document.getElementById('show-panel').classList.add('hidden');
}

function applyShow() {
    const show = {};
    document.querySelectorAll('#show-panel .prop input').forEach(c => {
        show[c.dataset.prop] = c.checked;
    });
    character.show = show;

    // как «Обновить»: перезаписываем ссылку и слот
    persistToLink();
    const list = getGallery();
    const item = list.find(x => x.id === character.id);
    if (item) {
        item.url = location.href;
        item.date = new Date().toISOString();
        saveGallery(list);
        slot = item;
    }

    dirty = false;
    closePanel();
    render();
    updateActions();
}

function renderPanelBlocks(container, blocks, isRoot) {
    for (const block of blocks) {
        const props = block.properties.filter(p => !p.isService);

        const blockEl = document.createElement('div');
        blockEl.className = 'block';

        const head = document.createElement('div');
        head.className = 'block-head';

        const blockCheck = document.createElement('input');
        blockCheck.type = 'checkbox';
        blockCheck.className = 'block-check';
        blockCheck.disabled = isRoot;
        blockCheck.addEventListener('change', () => {
            const value = blockCheck.checked;
            blockEl.querySelectorAll('.prop input').forEach(c => { c.checked = value; });
            updatePanelBlockState(blockEl);
        });
        head.appendChild(blockCheck);

        const title = document.createElement('span');
        title.className = 'block-title';
        title.textContent = block.title;
        head.appendChild(title);

        if (isRoot) {
            const lock = document.createElement('span');
            lock.className = 'lock';
            lock.textContent = '🔒 обязательно';
            head.appendChild(lock);
        }

        blockEl.appendChild(head);

        const propsEl = document.createElement('div');
        propsEl.className = 'props open';

        for (const prop of props) {
            const row = document.createElement('label');
            row.className = 'prop';

            const check = document.createElement('input');
            check.type = 'checkbox';
            check.checked = isRoot ? true : !!character.show[prop.propKey];
            check.disabled = isRoot;
            check.dataset.prop = prop.propKey;
            check.addEventListener('change', () => updatePanelBlockState(blockEl));
            row.appendChild(check);

            const name = document.createElement('span');
            name.textContent = prop.title;
            row.appendChild(name);

            propsEl.appendChild(row);
        }

        blockEl.appendChild(propsEl);
        container.appendChild(blockEl);

        if (isRoot) {
            blockCheck.checked = true;
            blockCheck.indeterminate = false;
        }
    }
}

function updatePanelBlockState(blockEl) {
    const checks = [...blockEl.querySelectorAll('.prop input')];
    const blockCheck = blockEl.querySelector('.block-check');
    const checkedCount = checks.filter(c => c.checked).length;

    if (checkedCount === 0) {
        blockCheck.checked = false;
        blockCheck.indeterminate = false;
    } else if (checkedCount === checks.length) {
        blockCheck.checked = true;
        blockCheck.indeterminate = false;
    } else {
        blockCheck.checked = false;
        blockCheck.indeterminate = true;
    }
}

// ---------- конфликт id ----------

function hashOf(url) {
    return String(url || '').split('#')[1] || '';
}

async function resolveConflict() {
    const choice = await showDialog(
        'Вам прислан персонаж с тем же идентификатором (id), который уже есть у вас в коллекции. Это разные персонажи. Что сделать?',
        [
            { label: 'Перезаписать своего', value: 'overwrite', primary: true },
            { label: 'Создать нового из присланного', value: 'fork' },
            { label: 'Отмена', value: 'cancel' }
        ]);

    if (choice === 'cancel' || choice === null) {
        location.replace('index.html');
        return false;
    }

    if (choice === 'overwrite') {
        const list = getGallery();
        const item = list.find(x => x.id === character.id);
        if (item) {
            item.url = location.href;
            item.date = new Date().toISOString();
            saveGallery(list);
            slot = item;
        }
        return true;
    }

    // fork: присланному даём новый id и заводим отдельный слот; твой старый остаётся
    character.id = newId();
    persistToLink();

    const item = {
        id: character.id,
        title: nextTitle(),
        date: new Date().toISOString(),
        url: location.href
    };
    const list = getGallery();
    list.push(item);
    saveGallery(list);
    slot = item;
    return true;
}