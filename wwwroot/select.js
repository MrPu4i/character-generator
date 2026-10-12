let catalog = [];

document.addEventListener('DOMContentLoaded', init);

async function init() {
    const response = await fetch('/api/catalog');
    catalog = await response.json();

    const rootBlocks = catalog.filter(b => b.isRoot);
    const otherBlocks = catalog.filter(b => !b.isRoot);

    renderBlocks(document.getElementById('root-blocks'), rootBlocks, true);
    renderBlocks(document.getElementById('other-blocks'), otherBlocks, false);

    document.querySelectorAll('#other-blocks .block').forEach(b => updateBlockState(b));
    document.getElementById('generate').addEventListener('click', generate);
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

        if (isRoot) {
            const lock = document.createElement('span');
            lock.className = 'lock';
            lock.textContent = '🔒 обязательно';
            head.appendChild(lock);
        }

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
            check.disabled = isRoot;
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

async function generate() {
    const show = {};
    document.querySelectorAll('.prop input').forEach(c => { show[c.dataset.prop] = c.checked; });

    const response = await fetch('/api/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ show })
    });
    const character = await response.json();

    location.href = buildCharacterLink(character);   // уходим по ссылке с персонажем
}