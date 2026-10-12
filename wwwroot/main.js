let catalog = [];

const RACE_EMOJI = { human: '🧑', elf: '🧝', dwarf: '⛏️' };

document.addEventListener('DOMContentLoaded', init);

async function init() {
    const response = await fetch('/api/catalog');
    catalog = await response.json();

    document.getElementById('create').addEventListener('click', goToSelect);
    document.getElementById('create-first').addEventListener('click', goToSelect);
    document.getElementById('export').addEventListener('click', exportList);
    document.getElementById('import').addEventListener('click', () =>
        document.getElementById('import-file').click());
    document.getElementById('import-file').addEventListener('change', importFile);

    render();
}

function goToSelect() {
    location.href = 'select.html';
}

// ---------- список ----------

function render() {
    const list = getGallery().sort((a, b) =>
        String(b.date || '').localeCompare(String(a.date || '')));

    const listEl = document.getElementById('list');
    const emptyEl = document.getElementById('empty');
    listEl.innerHTML = '';

    if (list.length === 0) {
        emptyEl.classList.remove('hidden');
        return;
    }

    emptyEl.classList.add('hidden');
    for (const item of list) listEl.appendChild(renderCard(item));
}

function renderCard(item) {
    const ch = decodeLink(item.url);

    const card = document.createElement('div');
    card.className = 'card';

    const emblem = document.createElement('div');
    emblem.className = 'card-emblem';
    const raceKey = ch ? effective(ch, 'race') : null;
    emblem.textContent = (raceKey && RACE_EMOJI[raceKey]) || '🎭';
    card.appendChild(emblem);

    const body = document.createElement('div');
    body.className = 'card-body';

    const title = document.createElement('div');
    title.className = 'card-title';
    title.textContent = cardTitle(item, ch);
    body.appendChild(title);

    const meta = document.createElement('div');
    meta.className = 'card-meta';
    const parts = [];
    if (ch) {
        for (const key of ['race', 'origin', 'age']) {
            const prop = findProp(catalog, key);
            if (!prop) continue;
            const text = displayValue(prop, effective(ch, key));
            if (text && text !== '—') parts.push(text);
        }
    }
    meta.textContent = parts.join(' · ');
    body.appendChild(meta);

    const date = document.createElement('div');
    date.className = 'card-date';
    date.textContent = formatDate(item.date);
    body.appendChild(date);

    card.appendChild(body);

    if (item.description) {
        const desc = document.createElement('div');
        desc.className = 'card-desc';
        desc.textContent = item.description;
        card.appendChild(desc);
    }

    const actions = document.createElement('div');
    actions.className = 'card-actions';
    actions.append(
        actionButton('Открыть', () => openCharacter(item)),
        actionButton('Ред. описание', () => editDescription(item)),
        actionButton('Дублировать', () => duplicateCharacter(item)),
        actionButton('Ссылка', () => copyCharacterLink(item)),
        actionButton('Удалить', () => deleteCharacter(item))
    );
    card.appendChild(actions);

    return card;
}

function actionButton(label, handler) {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.textContent = label;
    btn.addEventListener('click', handler);
    return btn;
}

// ---------- действия ----------

function openCharacter(item) {
    location.href = item.url;   // всегда по ссылке
}

async function editDescription(item) {
    const value = await showPrompt('Описание персонажа (для себя):', {
        value: item.description || '',
        maxLength: 120,
        placeholder: 'Например: для кампании по эльфам'
    });
    if (value === null) return;

    const list = getGallery();
    const existing = list.find(x => x.id === item.id);
    if (existing) existing.description = value.trim();
    saveGallery(list);
    render();
}

function duplicateCharacter(item) {
    const ch = decodeLink(item.url);
    if (!ch) { showToast('Не удалось прочитать персонажа'); return; }

    ch.id = newId();                       // копия — новый слот с новым id
    const link = buildCharacterLink(ch);

    const list = getGallery();
    list.push({
        id: ch.id,
        title: (item.title || 'Персонаж') + ' (копия)',
        date: new Date().toISOString(),
        url: link
    });
    saveGallery(list);
    render();
}

async function copyCharacterLink(item) {
    try {
        await navigator.clipboard.writeText(item.url);
        showToast('Ссылка скопирована');
    } catch (e) {
        prompt('Скопируйте ссылку:', item.url);
    }
}

async function deleteCharacter(item) {
    if (!(await showConfirm(`Удалить «${cardTitle(item, decodeLink(item.url))}»?`))) return;
    saveGallery(getGallery().filter(x => x.id !== item.id));
    render();
}

// ---------- импорт / экспорт ----------

function exportList() {
    const data = JSON.stringify(getGallery(), null, 2);
    const blob = new Blob([data], { type: 'application/json' });
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = 'characters.json';
    a.click();
    URL.revokeObjectURL(a.href);
}

async function importFile(event) {
    const file = event.target.files[0];
    if (!file) return;

    let incoming;
    try {
        incoming = JSON.parse(await file.text());
    } catch (e) {
        showToast('Некорректный файл');
        return;
    }

    if (!Array.isArray(incoming)) {
        showToast('Некорректный файл');
        return;
    }

    const list = getGallery();
    const ids = new Set(list.map(x => x.id));
    for (const item of incoming) {
        if (item && item.id && item.url && !ids.has(item.id)) list.push(item);
    }
    saveGallery(list);
    render();
    event.target.value = '';
}

function cardTitle(item, ch) {
    if (ch) {
        const nameProp = findProp(catalog, 'name');
        if (nameProp) {
            const text = displayValue(nameProp, effective(ch, 'name'));
            if (text && text !== '—') return text;
        }
    }
    return item.title || 'Безымянный персонаж';
}