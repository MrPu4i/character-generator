CREATE TABLE blocks (
    block_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    block_key        TEXT NOT NULL UNIQUE, -- Character, appearence
    title       TEXT NOT NULL, -- То что красиво пишется на сайте, Характер, Внешность, Основное
    sort_order  INTEGER NOT NULL,
    is_root     INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE properties (
    prop_id            INTEGER PRIMARY KEY AUTOINCREMENT,
    block_id      INTEGER NOT NULL REFERENCES blocks(block_id),
    prop_key          TEXT NOT NULL UNIQUE,
    title         TEXT NOT NULL,
    value_type    TEXT NOT NULL,          -- 'list' | 'number' | 'template'
    default_value TEXT,
    unit          TEXT,                   -- 'см', 'кг', 'лет'
    is_service    INTEGER NOT NULL DEFAULT 0,  -- служебные, только для шаблонов
    sort_order    INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE prop_values (
    val_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    prop_id    INTEGER NOT NULL REFERENCES properties(prop_id),
    val_key     TEXT NOT NULL UNIQUE,   --elf. male, red
    text        TEXT NOT NULL,       -- эльфик, мужчинка, красноееее
    weight     REAL NOT NULL DEFAULT 1,
    tags        TEXT          -- теги через запятую (пока так)
);