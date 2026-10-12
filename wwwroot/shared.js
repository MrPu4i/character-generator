// ===== Ссылки и персонаж =====

const CHARACTER_VERSION = 1;

function decodeCharacterFromHash() {
    const hash = location.hash.slice(1);
    if (!hash) return null;
    try {
        const json = LZString.decompressFromEncodedURIComponent(hash);
        return json ? normalizeCharacter(JSON.parse(json)) : null;
    } catch (e) {
        return null;
    }
}

function normalizeCharacter(ch) {
    if (!ch || typeof ch !== 'object') return null;

    const out = {
        v: typeof ch.v === 'number' ? ch.v : 1,
        val: (ch.val && typeof ch.val === 'object') ? ch.val : {},
        fix: (ch.fix && typeof ch.fix === 'object') ? ch.fix : {},
        show: (ch.show && typeof ch.show === 'object') ? ch.show : {}
    };
    if (ch.id) out.id = ch.id;

    // сюда будут добавляться миграции для будущих версий
    if (out.v < CHARACTER_VERSION) out.v = CHARACTER_VERSION;

    return out;
}

function encodeCharacter(character) {
    return LZString.compressToEncodedURIComponent(JSON.stringify(character));
}

// каталог страницы + имя файла -> стабильная ссылка на экран персонажа
function buildCharacterLinkFromHash(hash) {
    const dir = location.origin + location.pathname.replace(/\/[^/]*$/, '/');
    return dir + 'character.html#' + hash;
}

function buildCharacterLink(character) {
    return buildCharacterLinkFromHash(encodeCharacter(character));
}

function decodeHash(hash) {
    if (!hash) return null;
    try {
        const json = LZString.decompressFromEncodedURIComponent(hash);
        return json ? normalizeCharacter(JSON.parse(json)) : null;
    } catch (e) {
        return null;
    }
}

// у слота храним только «хвост» (data) — без домена. url оставляем для старых записей.
function slotHash(item) {
    if (item.data) return item.data;
    if (item.url) return String(item.url).split('#')[1] || '';
    return '';
}

function newId() {
    return crypto.randomUUID
        ? crypto.randomUUID()
        : String(Date.now()) + '-' + Math.random().toString(16).slice(2);
}

// ===== Значения =====

function effective(character, key) {
    return Object.prototype.hasOwnProperty.call(character.fix, key)
        ? character.fix[key]
        : character.val[key];
}

function findProp(catalog, key) {
    for (const block of catalog) {
        const found = block.properties.find(p => p.propKey === key);
        if (found) return found;
    }
    return null;
}

function valueText(prop, raw) {
    if (raw === undefined || raw === null || raw === '') return '';
    if (prop.valueType === 'list') {
        const v = prop.values.find(x => x.valKey === raw);
        return v ? v.text : raw;
    }
    return raw;
}

function displayValue(prop, raw) {
    const text = valueText(prop, raw);
    if (!text) return '—';
    return prop.unit ? text + ' ' + prop.unit : text;
}

// ===== Коллекция (слоты) =====

function getGallery() {
    return JSON.parse(localStorage.getItem('characters') || '[]');
}

function saveGallery(list) {
    localStorage.setItem('characters', JSON.stringify(list));
}

function findSlotById(id) {
    if (!id) return null;
    return getGallery().find(x => x.id === id) || null;
}

function nextTitle() {
    let max = 0;
    for (const item of getGallery()) {
        const m = /^Персонаж\s+(\d+)$/.exec(item.title || '');
        if (m) max = Math.max(max, Number(m[1]));
    }
    return 'Персонаж ' + (max + 1);
}

// ===== Мелочи =====

function formatDate(iso) {
    if (!iso) return '';
    const d = new Date(iso);
    return isNaN(d)
        ? ''
        : d.toLocaleDateString('ru-RU', { day: '2-digit', month: '2-digit', year: 'numeric' });
}

let __toastTimer = null;
function showToast(text) {
    const el = document.getElementById('toast');
    if (!el) return;
    el.textContent = text;
    el.classList.remove('hidden');
    clearTimeout(__toastTimer);
    __toastTimer = setTimeout(() => el.classList.add('hidden'), 2000);
}

// ===== Модальное окно =====

function ensureModal() {
    let modal = document.getElementById('modal');
    if (modal) return modal;

    modal = document.createElement('div');
    modal.id = 'modal';
    modal.className = 'modal hidden';
    modal.innerHTML =
        '<div class="modal-box">' +
        '<p id="modal-text"></p>' +
        '<div id="modal-buttons" class="modal-buttons"></div>' +
        '</div>';
    document.body.appendChild(modal);
    return modal;
}

// buttons: [{ label, value, primary, collectInput }]
// options: { input: { value, placeholder, maxLength } }
function openModal(text, buttons, options = {}) {
    return new Promise((resolve) => {
        const modal = ensureModal();
        const box = modal.querySelector('.modal-box');
        const textEl = document.getElementById('modal-text');
        const buttonsEl = document.getElementById('modal-buttons');

        textEl.textContent = text;

        let input = box.querySelector('.modal-input');
        if (options.input) {
            if (!input) {
                input = document.createElement('input');
                input.type = 'text';
                input.className = 'modal-input';
                box.insertBefore(input, buttonsEl);
            }
            input.style.display = 'block';
            input.value = options.input.value ?? '';
            input.maxLength = options.input.maxLength ?? 200;
            input.placeholder = options.input.placeholder ?? '';
        } else if (input) {
            input.style.display = 'none';
        }

        const finish = (value) => {
            modal.classList.add('hidden');
            resolve(value);
        };

        buttonsEl.innerHTML = '';
        for (const b of buttons) {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.textContent = b.label;
            if (b.primary) btn.className = 'primary';
            btn.addEventListener('click', () => finish(b.collectInput ? input.value : b.value));
            buttonsEl.appendChild(btn);
        }

        if (options.input && input) {
            input.onkeydown = (e) => {
                if (e.key === 'Enter') {
                    const primary = buttons.find(b => b.primary);
                    finish(primary && primary.collectInput ? input.value : (primary ? primary.value : null));
                } else if (e.key === 'Escape') {
                    finish(null);
                }
            };
            input.focus();
            input.select();
        }

        modal.classList.remove('hidden');
    });
}

function showDialog(text, buttons) {
    return openModal(text, buttons);
}

function showConfirm(text, okLabel = 'Удалить') {
    return openModal(text, [
        { label: okLabel, value: true, primary: true },
        { label: 'Отмена', value: false }
    ]).then(v => v === true);
}

function showPrompt(text, options = {}) {
    return openModal(
        text,
        [
            { label: 'Сохранить', value: 'ok', primary: true, collectInput: true },
            { label: 'Отмена', value: null }
        ],
        { input: options }
    );
}

function fillMissingShow(character, catalog) {
    for (const block of catalog) {
        for (const prop of block.properties) {
            if (!(prop.propKey in character.show)) {
                character.show[prop.propKey] = true;   // новое свойство — по умолчанию показано
            }
        }
    }
}

const MAX_URL_LENGTH = 2000;

function updateLinkWarning() {
    const el = document.getElementById('link-warning');
    if (!el) return;

    const len = location.href.length;
    if (len > MAX_URL_LENGTH) {
        el.textContent = 'Ссылка длинная: ' + len + ' символов. В некоторых браузерах '
            + 'и мессенджерах она может не открыться — сохраните важное в описании.';
        el.classList.remove('hidden');
    } else {
        el.classList.add('hidden');
    }
}
