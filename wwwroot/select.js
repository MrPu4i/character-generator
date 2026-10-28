let catalog = [];
const rootSelections = {};   // prop_key -> val_key (нет ключа = «случайно»)

const ICONS = {
    race: { human: '🧑', elf: '🧝', dwarf: '⛏️' },
    gender: { male: '♂️', female: '♀️', nonbinary: '⚧️' },
    origin: { noble: '👑', commoner: '🌾', artisan: '🔨' }
};

function iconFor(propKey, valKey) {
    return (ICONS[propKey] && ICONS[propKey][valKey]) || '🎭';
}

document.addEventListener('DOMContentLoaded', init);

async function init() {
    try {
        const response = await fetch('/api/catalog');
        if (!response.ok) throw new Error('HTTP ' + response.status);
        catalog = await response.json();
    } catch (e) {
        showServerDown();
        return;
    }

    renderRootChoices();
    renderShowBlocks();
    document.getElementById('generate').addEventListener('click', generate);
}

function showServerDown() {
    const main = document.querySelector('main');
    const msg = document.createElement('div');
    msg.className = 'warning';
    msg.textContent = 'Сервер недоступен. Генерация персонажа временно невозможна — попробуйте позже.';

    const layout = main.querySelector('.select-layout');
    main.insertBefore(msg, layout || main.firstChild);

    const btn = document.getElementById('generate');
    if (btn) btn.disabled = true;
}

// ---------- левая колонка: основные черты ----------

function renderRootChoices() {
    const container = document.getElementById('root-choices');
    container.innerHTML = '';

    for (const block of catalog.filter(b => b.isRoot)) {
        for (const prop of block.properties.filter(p => !p.isService)) {
            container.appendChild(renderRootProp(prop));
        }
    }
}

function isNumericProp(prop) {
    return prop.values.length > 0 && prop.values.every(v => v.text !== '' && !isNaN(Number(v.text)));
}

function renderRootProp(prop) {
    const wrap = document.createElement('div');
    wrap.className = 'root-prop';

    const title = document.createElement('div');
    title.className = 'root-prop-title';
    title.textContent = prop.title;
    wrap.appendChild(title);

    // числовое свойство (например, возраст) — поле ввода
    if (isNumericProp(prop)) {
        const input = document.createElement('input');
        input.type = 'number';
        input.className = 'root-number';
        input.placeholder = 'случайно';
        input.min = '0';
        input.addEventListener('input', () => {
            if (input.value.trim() === '') delete rootSelections[prop.propKey];
            else rootSelections[prop.propKey] = input.value.trim();
        });
        wrap.appendChild(input);
        return wrap;
    }

    // списочное свойство — сетка иконок + названий
    const choices = document.createElement('div');
    choices.className = 'choices';
    choices.appendChild(makeChoice(prop, null, '🎲', 'Случайно', true));

    for (const value of prop.values) {
        choices.appendChild(makeChoice(prop, value.valKey, iconFor(prop.propKey, value.valKey), value.text));
    }

    wrap.appendChild(choices);
    return wrap;
}

function makeChoice(prop, valKey, icon, label, isRandom = false) {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'choice' + (isRandom ? ' selected' : '');

    const iconEl = document.createElement('span');
    iconEl.className = 'choice-icon';
    iconEl.textContent = icon;
    btn.appendChild(iconEl);

    const nameEl = document.createElement('span');
    nameEl.textContent = label;
    btn.appendChild(nameEl);

    btn.addEventListener('click', () => {
        btn.closest('.choices').querySelectorAll('.choice').forEach(c => c.classList.remove('selected'));
        btn.classList.add('selected');

        if (valKey) rootSelections[prop.propKey] = valKey;
        else delete rootSelections[prop.propKey];
    });

    return btn;
}

// ---------- правая колонка: что показывать ----------

function renderShowBlocks() {
    renderBlocks(document.getElementById('other-blocks'), catalog.filter(b => !b.isRoot), false);
    document.querySelectorAll('#other-blocks .block').forEach(b => updateBlockState(b));
}

function renderBlocks(container, blocks, isRoot) {
    for (const block of blocks) {
        const props = block.properties.filter(p => !p.isService);

        const blockEl = document.createElement('div');
        blockEl.className = 'block';

        const head = document.createElement('div');
        head.className = 'block-head';

        const blockCheck = document.createElement('input');
        blockCheck.type = 'checkbox';
        blockCheck.className = 'block-check';
        blockCheck.checked = true;
        blockCheck.disabled = isRoot;
        blockCheck.addEventListener('change', () => {
            const value = blockCheck.checked;
            blockEl.querySelectorAll('.prop input').forEach(c => { c.checked = value; });
            updateBlockState(blockEl);
        });
        head.appendChild(blockCheck);

        const title = document.createElement('span');
        title.className = 'block-title';
        title.textContent = block.title;
        head.appendChild(title);

        const expandIcon = document.createElement('button');
        expandIcon.type = 'button';
        expandIcon.className = 'expand';
        expandIcon.textContent = '▾';

        const propsEl = document.createElement('div');
        propsEl.className = 'props open';

        expandIcon.addEventListener('click', () => {
            propsEl.classList.toggle('open');
            expandIcon.textContent = propsEl.classList.contains('open') ? '▾' : '▸';
        });
        head.appendChild(expandIcon);

        blockEl.appendChild(head);

        for (const prop of props) {
            const row = document.createElement('label');
            row.className = 'prop';

            const check = document.createElement('input');
            check.type = 'checkbox';
            check.checked = true;
            check.dataset.prop = prop.propKey;
            check.addEventListener('change', () => updateBlockState(blockEl));
            row.appendChild(check);

            const name = document.createElement('span');
            name.textContent = prop.title;
            row.appendChild(name);

            propsEl.appendChild(row);
        }

        blockEl.appendChild(propsEl);
        container.appendChild(blockEl);
    }
}

function updateBlockState(blockEl) {
    const checks = [...blockEl.querySelectorAll('.prop input')];
    const blockCheck = blockEl.querySelector('.block-check');
    const counted = checks.filter(c => c.checked).length;

    if (counted === 0) {
        blockCheck.checked = false;
        blockCheck.indeterminate = false;
    } else if (counted === checks.length) {
        blockCheck.checked = true;
        blockCheck.indeterminate = false;
    } else {
        blockCheck.checked = false;
        blockCheck.indeterminate = true;
    }
}

// ---------- генерация ----------

async function generate() {
    const show = {};

    // основные черты показываем всегда
    for (const block of catalog.filter(b => b.isRoot)) {
        for (const prop of block.properties) {
            if (!prop.isService) show[prop.propKey] = true;
        }
    }

    // остальные — по галочкам
    document.querySelectorAll('#other-blocks .prop input').forEach(c => {
        show[c.dataset.prop] = c.checked;
    });

    const response = await fetch('/api/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ show, preset: rootSelections })
    });
    const character = await response.json();

    location.href = buildCharacterLink(character);
}