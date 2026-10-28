let catalog = [];
let character = null;
let dirty = false;
let slot = null;

document.addEventListener('DOMContentLoaded', init);

async function init() {
    character = decodeCharacterFromHash();
    if (!character) {
        location.replace('index.html');
        return;
    }

    slot = character.id ? findSlotById(character.id) : null;

    if (slot && hashOf(location.href) !== slotHash(slot)) {
        const resolved = await resolveConflict();
        if (!resolved) return;
    }

    fillMissingShow(character);   // по ключам из val, каталог не нужен

    document.getElementById('create').addEventListener('click', createSlot);
    document.getElementById('update').addEventListener('click', updateSlot);
    document.getElementById('save-as-new').addEventListener('click', saveAsNew);
    document.getElementById('delete').addEventListener('click', deleteSlot);

    document.getElementById('panel-toggle').addEventListener('click', openPanel);
    document.getElementById('panel-apply').addEventListener('click', applyShow);
    document.getElementById('panel-cancel').addEventListener('click', closePanel);
    document.getElementById('panel-backdrop').addEventListener('click', closePanel);

    document.getElementById('prompt').addEventListener('click', copyPrompt);

    updateRemoteAvailability();
    render();             // сначала «машинный» вид
    updateActions();
    updateLinkWarning();

    loadCatalog();        // затем — попытка получить каталог
}

async function loadCatalog() {
    try {
        const response = await fetch('/api/catalog');
        if (!response.ok) throw new Error('HTTP ' + response.status);
        catalog = await response.json();
        fillMissingShow(character, catalog);
        updateRemoteAvailability();
        render();             // перерисовываем красиво
        updateActions();
    } catch (e) {
        catalog = [];
        updateRemoteAvailability();
        showToast('Сервер недоступен: показаны значения из ссылки');
    }
}

function updateRemoteAvailability() {
    const available = catalog.length > 0;

    const promptBtn = document.getElementById('prompt');
    if (promptBtn) {
        promptBtn.disabled = !available;
        promptBtn.title = available
            ? 'Скопировать промпт для ИИ-генератора картинок'
            : 'Нет доступа к серверу';
    }

    const panelBtn = document.getElementById('panel-toggle');
    if (panelBtn) {
        panelBtn.disabled = !available;
        panelBtn.title = available ? '' : 'Нет доступа к серверу';
    }
}

// ---------- рендер ----------



function startEdit(row, item) {
    const { propKey, prop } = item;

    const valueEl = row.querySelector('.prop-value');
    const raw = effective(character, propKey);

    const input = document.createElement('input');
    input.type = 'text';
    input.className = 'edit-input';
    input.value = prop ? valueText(prop, raw) : (raw === undefined || raw === null ? '' : String(raw));

    valueEl.replaceWith(input);
    input.focus();
    input.select();

    const before = input.value;

    let finished = false;
    function finish(save) {
        if (finished) return;
        finished = true;

        if (save && input.value !== before) {
            character.fix[propKey] = input.value;
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

function render() {
    const content = document.getElementById('content');
    content.innerHTML = '';

    let blocksInfo;

    if (catalog.length > 0) {
        blocksInfo = catalog
            .map(block => ({
                title: block.title,
                isRoot: block.isRoot,
                block: block,
                canRegenerate: true,
                props: block.properties
                    .filter(p => !p.isService && character.show[p.propKey])
                    .map(p => ({ propKey: p.propKey, title: p.title, prop: p }))
            }))
            .filter(b => b.props.length > 0 || b.isRoot);
    } else {
        // каталога нет — показываем ключи прямо из ссылки
        const keys = Object.keys(character.val).filter(k => character.show[k] !== false);
        blocksInfo = [{
            title: 'Значения персонажа',
            isRoot: true,
            block: null,
            canRegenerate: false,
            props: keys.map(k => ({ propKey: k, title: k, prop: null }))
        }];
    }

    for (const info of blocksInfo) {
        const blockEl = document.createElement('section');
        blockEl.className = 'block';

        const head = document.createElement('div');
        head.className = 'block-head';

        const title = document.createElement('span');
        title.className = 'block-title';
        title.textContent = info.title;
        head.appendChild(title);

        if (info.canRegenerate) {
            const regen = document.createElement('button');
            regen.type = 'button';
            regen.className = 'regen';
            regen.title = 'Перегенерировать блок';
            regen.textContent = '🎲';
            regen.addEventListener('click', () => regenerateBlock(info.block));
            head.appendChild(regen);
        }

        blockEl.appendChild(head);

        const propsEl = document.createElement('div');
        propsEl.className = 'props open';
        for (const item of info.props) propsEl.appendChild(renderRow(item));
        blockEl.appendChild(propsEl);

        content.appendChild(blockEl);
    }

    // подсказка, если дополнительные блоки скрыты
    const nonRootWithProps = blocksInfo.filter(b => !b.isRoot && b.props.length > 0).length;
    if (catalog.length > 0 && nonRootWithProps === 0) {
        const note = document.createElement('p');
        note.className = 'hint';
        note.textContent = 'Дополнительные блоки скрыты. Нажмите «Показать», чтобы вернуть их.';
        content.appendChild(note);
    }
}

function renderRow(item) {
    const { propKey, title, prop } = item;

    const row = document.createElement('div');
    row.className = 'prop-row';

    const name = document.createElement('span');
    name.className = 'prop-name';
    name.textContent = title + ':';
    row.appendChild(name);

    const edited = Object.prototype.hasOwnProperty.call(character.fix, propKey);
    const raw = effective(character, propKey);

    const valueEl = document.createElement('span');
    valueEl.className = 'prop-value';
    valueEl.textContent = prop ? displayValue(prop, raw) : rawDisplay(raw);
    valueEl.title = 'Двойной клик — изменить';
    valueEl.addEventListener('dblclick', () => startEdit(row, item));

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
            delete character.fix[propKey];
            markDirty();
            render();
        });
        row.appendChild(revert);
    }

    return row;
}

function rawDisplay(raw) {
    if (raw === undefined || raw === null || raw === '') return '—';
    return String(raw);
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
    const hash = encodeCharacter(character);
    history.replaceState(null, '', buildCharacterLinkFromHash(hash));
    updateLinkWarning();
    return hash;
}

function createSlot() {
    if (!character.id) character.id = newId();
    const hash = persistToLink();

    const item = {
        id: character.id,
        title: nextTitle(),
        date: new Date().toISOString(),
        data: hash
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
    const hash = persistToLink();

    const list = getGallery();
    const item = list.find(x => x.id === character.id);
    if (item) {
        item.data = hash;
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
    const hash = persistToLink();

    const item = {
        id: character.id,
        title: nextTitle(),
        date: new Date().toISOString(),
        data: hash
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
    const result = await apiPost('/api/generate', { fix, show });
    if (!result) return;

    character = { ...result, id: character.id };
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

    const result = await apiPost('/api/regenerate', {
        v: character.v,
        id: character.id,
        val: character.val,
        show: character.show,
        fix: newFix,
        block: block.blockKey
    });

    if (!result) return;

    character = { ...result, id: character.id };
    persistToLink();
    dirty = false;
    render();
    updateActions();
}
// ---------- боковая панель «Показать» ----------

function openPanel() {
    if (catalog.length === 0) {
        showToast('Нет доступа к серверу');
        return;
    }
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
    const hash = persistToLink();
    const list = getGallery();
    const item = list.find(x => x.id === character.id);
    if (item) {
        item.data = hash;
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
            item.data = hashOf(location.href);
            item.date = new Date().toISOString();
            saveGallery(list);
            slot = item;
        }
        return true;
    }

    // fork: присланному даём новый id и заводим отдельный слот; твой старый остаётся
    character.id = newId();
    const hash = persistToLink();

    const item = {
        id: character.id,
        title: nextTitle(),
        date: new Date().toISOString(),
        data: hash
    };
    const list = getGallery();
    list.push(item);
    saveGallery(list);
    slot = item;
    return true;
}

// ---------- промпт для ИИ-генератора картинок ----------

function buildPrompt() {
    const lines = ['Нарисуй фэнтезийного персонажа по описанию:'];

    for (const block of catalog) {
        for (const prop of block.properties) {
            if (prop.isService) continue;
            if (!character.show[prop.propKey]) continue;   // только то, что пользователь выбрал показывать

            const text = displayValue(prop, effective(character, prop.propKey));
            if (!text || text === '—') continue;

            lines.push('- ' + prop.title + ': ' + text);
        }
    }

    return lines.join('\n');
}

async function copyPrompt() {
    if (catalog.length === 0) {
        showToast('Нет доступа к серверу');
        return;
    }
    const text = buildPrompt();

    try {
        await navigator.clipboard.writeText(text);
        showToast('Промпт скопирован');
    } catch (e) {
        // если браузер не дал доступ к буферу — покажем текст, чтобы скопировать вручную
        openModal(text, [{ label: 'Закрыть', value: true, primary: true }]);
    }
}

// ---------- ошибки при перегенрации ----------

async function apiPost(url, body) {
    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body)
        });
        if (!response.ok) throw new Error('HTTP ' + response.status);
        return await response.json();
    } catch (e) {
        showToast('Сервер временно недоступен');
        return null;
    }
}