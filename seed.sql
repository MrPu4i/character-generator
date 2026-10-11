-- ===== Блоки =====
INSERT INTO blocks (block_key, title, sort_order, is_root) VALUES
('core',   'Основное', 1, 1),
('appearance', 'Внешний вид',    2, 0),
('character',  'Характер',       3, 0);

-- ===== Свойства =====
INSERT INTO properties (block_id, prop_key, title, value_type, default_value, unit, is_service, sort_order) VALUES
((SELECT block_id FROM blocks WHERE block_key='core'), 'race',   'Раса',          'list',     NULL, NULL,  0, 1),
((SELECT block_id FROM blocks WHERE block_key='core'), 'gender', 'Пол',           'list',     NULL, NULL,  0, 2),
((SELECT block_id FROM blocks WHERE block_key='core'), 'age',    'Возраст',       'list',     NULL, 'лет', 0, 3),
((SELECT block_id FROM blocks WHERE block_key='core'), 'origin', 'Происхождение', 'list',     NULL, NULL,  0, 4),
((SELECT block_id FROM blocks WHERE block_key='appearance'), 'height', 'Рост',       'list',     NULL, 'см',  0, 1),
((SELECT block_id FROM blocks WHERE block_key='appearance'), 'weight', 'Вес',        'computed', NULL, 'кг',  0, 2),
((SELECT block_id FROM blocks WHERE block_key='appearance'), 'hair_color', 'Цвет волос',  'list', NULL, NULL, 0, 3),
((SELECT block_id FROM blocks WHERE block_key='appearance'), 'build',  'Телосложение', 'list',     NULL, NULL, 0, 4),
((SELECT block_id FROM blocks WHERE block_key='character'), 'temperament',   'Темперамент', 'list',     NULL, NULL,  0, 1),
((SELECT block_id FROM blocks WHERE block_key='character'), 'worldview',   'Мировоззрение',  'list',     NULL, NULL,  0, 2);

-- ===== ОСНОВНЫЕ =====
-- ===== Расы =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='race'), 'human', 'Человек', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'elf',   'Эльф',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'dwarf', 'Дварф',    1, NULL);

-- ===== Пол =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='gender'), 'male',   'Мужской', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='gender'), 'female', 'Женский', 1, NULL);

-- ===== Возраст =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_20',  '20',  1, 'race=human'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_35',  '35',  1, 'race=human,race=dwarf'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_140', '140', 1, 'race=elf');

-- ===== Происхождение =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='origin'), 'noble',    'Знатный род', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='origin'), 'commoner', 'Простолюдин', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='origin'), 'artisan',  'Ремесленник', 1, NULL);

-- ===== Остальные =====

-- ===== Телосложение =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='build'), 'slim',   'Худощавое', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='build'), 'normal', 'Обычное',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='build'), 'stocky', 'Крепкое',   1, NULL);

-- ===== Рост =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='height'), 'h_100', '100', 1, 'race=dwarf,gender=female'),
((SELECT prop_id FROM properties WHERE prop_key='height'), 'h_130', '130', 1, 'race=dwarf,race=elf,gender=female'),
((SELECT prop_id FROM properties WHERE prop_key='height'), 'h_170', '170', 1, 'race=human,race=elf'),
((SELECT prop_id FROM properties WHERE prop_key='height'), 'h_185', '185', 1, 'race=human,gender=male');

-- ===== Цвет волос =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='hair_color'), 'silver', 'Серебристый', 1, 'race=elf,origin=noble'),
((SELECT prop_id FROM properties WHERE prop_key='hair_color'), 'blond',  'Белокурый',   1, 'race=human,race=elf,origin=noble'),
((SELECT prop_id FROM properties WHERE prop_key='hair_color'), 'red',    'Рыжий',       1, 'race=human,race=dwarf,origin=commoner'),
((SELECT prop_id FROM properties WHERE prop_key='hair_color'), 'black',  'Чёрный',      1, 'race=human,race=dwarf');

-- ===== Темперамент =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='temperament'), 'sanguine',   'Сангвиник', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='temperament'), 'choleric',   'Холерик',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='temperament'), 'phlegmatic', 'Флегматик', 1, NULL);

-- ===== Мироощущение =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'good',    'Добрый',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'neutral', 'Нейтральный', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'evil',    'Злой',        1, NULL);