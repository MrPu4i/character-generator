-- ===== Блоки =====
INSERT INTO blocks (block_key, title, sort_order, is_root) VALUES
('core', 'Основное', 1, 1),
('person', 'Персона', 2, 0),
('appearance', 'Внешний вид', 3, 0),
('character', 'Характер', 4, 0),
('skills', 'Навыки', 5, 0),
('background', 'Биография', 6, 0),
('motivation', 'Мотивы и цели', 7, 0);

--#region ===== Свойства =====
INSERT INTO properties (block_id, prop_key, title, value_type, default_value, unit, is_service, sort_order) VALUES
((SELECT block_id FROM blocks WHERE block_key='core'), 'race',   'Раса',          'list',     NULL, NULL,  0, 1),
((SELECT block_id FROM blocks WHERE block_key='core'), 'gender', 'Пол',           'list',     NULL, NULL,  0, 2),
((SELECT block_id FROM blocks WHERE block_key='core'), 'age',    'Возраст',       'list',     NULL, 'лет', 0, 3),
((SELECT block_id FROM blocks WHERE block_key='core'), 'origin', 'Происхождение', 'list',     NULL, NULL,  0, 4),

((SELECT block_id FROM blocks WHERE block_key='person'), 'name', 'Имя', 'list', NULL, NULL,  0, 1),
((SELECT block_id FROM blocks WHERE block_key='person'), 'surname', 'Фамилия', 'list', NULL, NULL,  0, 2),
((SELECT block_id FROM blocks WHERE block_key='person'), 'class', 'Класс', 'list', NULL, NULL,  0, 3),

((SELECT block_id FROM blocks WHERE block_key='appearance'), 'height', 'Рост', 'list', NULL, 'см',  0, 1),
((SELECT block_id FROM blocks WHERE block_key='appearance'), 'weight', 'Вес', 'computed', NULL, 'кг',  0, 2),
((SELECT block_id FROM blocks WHERE block_key='appearance'), 'build',  'Телосложение', 'list', NULL, NULL, 0, 3),
((SELECT block_id FROM blocks WHERE block_key='appearance'), 'skin_tone',  'Цвет кожи', 'list', NULL, NULL, 0, 4),
((SELECT block_id FROM blocks WHERE block_key='appearance'), 'hair_color', 'Цвет волос', 'list', NULL, NULL, 0, 5),
((SELECT block_id FROM blocks WHERE block_key='appearance'), 'hair_type', 'Тип волос',  'list', NULL, NULL, 0, 6),
((SELECT block_id FROM blocks WHERE block_key='appearance'), 'hair_length', 'Длина волос',  'list', NULL, 'см', 0, 7),
((SELECT block_id FROM blocks WHERE block_key='appearance'), 'look_style',  'Стиль одежды', 'list',     NULL, NULL, 0, 8),
((SELECT block_id FROM blocks WHERE block_key='appearance'), 'feature',  'Особенность', 'list',     NULL, NULL, 0, 9),

((SELECT block_id FROM blocks WHERE block_key='character'), 'temperament', 'Темперамент', 'list', NULL, NULL,  0, 1),
((SELECT block_id FROM blocks WHERE block_key='character'), 'virtue', 'Главная добродетель', 'list', NULL, NULL,  0, 2),
((SELECT block_id FROM blocks WHERE block_key='character'), 'flaw', 'Главный порок', 'list', NULL, NULL,  0, 3),
((SELECT block_id FROM blocks WHERE block_key='character'), 'quirk', 'Странность', 'list', NULL, NULL,  0, 4),
((SELECT block_id FROM blocks WHERE block_key='character'), 'fear', 'Страх', 'list', NULL, NULL,  0, 5),
((SELECT block_id FROM blocks WHERE block_key='character'), 'trust', 'Отношение к незнакомцам', 'list', NULL, NULL,  0, 6),
((SELECT block_id FROM blocks WHERE block_key='character'), 'worldview', 'Мировоззрение', 'list', NULL, NULL,  0, 7),

((SELECT block_id FROM blocks WHERE block_key='skills'), 'profession', 'Основное ремесло', 'list', NULL, NULL,  0, 1),
((SELECT block_id FROM blocks WHERE block_key='skills'), 'profession_lvl', 'Уровень владения ремеслом', 'list', NULL, NULL,  0, 2),
((SELECT block_id FROM blocks WHERE block_key='skills'), 'combat_style', 'Стиль боя', 'list', NULL, NULL,  0, 3),
((SELECT block_id FROM blocks WHERE block_key='skills'), 'magic', 'Магия', 'list', NULL, NULL,  0, 4),

((SELECT block_id FROM blocks WHERE block_key='background'), 'childhood',   'Детство', 'list',     NULL, NULL,  0, 1),
((SELECT block_id FROM blocks WHERE block_key='background'), 'key_event',   'Переломное событие', 'list',     NULL, NULL,  0, 2),
((SELECT block_id FROM blocks WHERE block_key='background'), 'secret',   'Тайна', 'list',     NULL, NULL,  0, 3),

((SELECT block_id FROM blocks WHERE block_key='motivation'), 'short_term_goal', 'Текущая цель', 'list', NULL, NULL,  0, 1),
((SELECT block_id FROM blocks WHERE block_key='motivation'), 'long_term_dream', 'Мечта', 'list', NULL, NULL,  0, 2),
((SELECT block_id FROM blocks WHERE block_key='motivation'), 'motivation', 'Мотивация', 'list', NULL, NULL,  0, 3);
--#endregion

--#region ===== ОСНОВНЫЕ =====
-- ===== Расы =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='race'), 'human', 'Человек', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'elf',   'Эльф',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'dwarf', 'Дварф',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'gnom', 'Гном', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'goblin',   'Гоблин',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'dragonborn', 'Драконорождённый',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'orc', 'Орк', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'halfling',   'Полурослик',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'half-elf', 'Полуэльф',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'fairy', 'Фейри',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'tabaxi', 'Табакси', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'lizardman',   'Людоящер',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'centaur', 'Кентавр',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'beastman', 'Зверолюд',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'harpy', 'Гарпия',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='race'), 'undead', 'Нежить', 1, NULL);

-- ===== Пол =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='gender'), 'male',   'Мужской', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='gender'), 'female', 'Женский', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='gender'), 'nonbinary', 'Небинарный', 1, NULL);

-- ===== Возраст =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_15',  '15',  1, 'race=human,race=orc'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_18',  '18',  1, 'race=human,race=orc'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_20', '20', 1,   'race=human,race=orc'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_30',  '30',  1, 'race=human,race=orc'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_40',  '40',  1, 'race=human,race=orc'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_50', '50', 1,   'race=human,race=orc'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_60',  '60',  1, 'race=human,race=orc'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_70',  '70',  1, 'race=human'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_80',  '80',  1, 'race=human,race=halfling'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_90', '90', 1, 'race=halfling'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_100',  '100',  1, 'race=human,race=halfling,race=dwarf'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_110',  '110',  1, 'race=dwarf,race=elf,race=halfling'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_120', '120', 1, 'race=elf,race=elf,race=dwarf'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_130', '130', 1, 'race=elf,race=elf,race=dwarf'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_140',  '140',  1, 'race=elf,race=dwarf'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_150',  '150',  1, 'race=dwarf,race=elf'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_160',  '160',  1, 'race=dwarf,race=elf'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_170', '170', 1, 'race=elf,race=dwarf'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_180',  '180',  1, 'race=elf,race=dwarf'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_190',  '190',  1, 'race=elf,race=dwarf'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_200', '200', 1, 'race=elf,race=dwarf'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_300',  '300',  1, 'race=elf,race=dwarf'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_400',  '400',  1, 'race=elf,race=dwarf,race=dragonborn'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_600',  '600',  1, 'race=elf,race=dragonborn'),
((SELECT prop_id FROM properties WHERE prop_key='age'), 'age_1000',  '1000',  1, 'race=elf,race=dragonborn');

-- ===== Происхождение =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='origin'), 'noble',    'Знатный род', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='origin'), 'commoner', 'Простолюдин', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='origin'), 'artisan',  'Ремесленник', 1, NULL);
--#endregion

--#region ===== ПЕРСОНА =====
-- ===== Имя =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_aelin',  'Аэлин',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_aiven',  'Айвен',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_alan',   'Алан',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_amri',   'Амри',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_anvi',   'Анви',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_arden',  'Арден',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_ari',    'Ари',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_bri',    'Бри',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_vel',    'Вэл',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_vain',   'Вэйн',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_gael',   'Гаэль',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_dari',   'Дари',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_daren',  'Дарэн',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_eira',   'Эйра',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_elai',   'Элай',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_emri',   'Эмри',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_erin',   'Эрин',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_zara',   'Зара',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_iven',   'Ивен',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_ilei',   'Илэй',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_inne',   'Иннэ',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_ien',    'Йен',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_kei',    'Кэй',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_keil',   'Кейл',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_kir',    'Кир',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_laen',   'Лаэн',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_lian',   'Лиан',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_lin',    'Лин',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_leir',   'Лэйр',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_mael',   'Маэль',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_mira',   'Мира',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_mor',    'Мор',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_naira',  'Найра',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_neris',  'Нэрис',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_orin',   'Орин',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_rei',    'Рэй',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_rin',    'Рин',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_rovan',  'Рован',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_sael',   'Саэль',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_sei',    'Сэй',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_selin',  'Сэлин',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_tael',   'Таэль',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_taris',  'Тарис',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_tiel',   'Тиэль',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_torn',   'Торн',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_fei',    'Фэй',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_hel',    'Хэл',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_shei',   'Шэй',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_eiden',  'Эйден',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='name'), 'name_yuna',   'Юна',    1, NULL);

-- ===== Фамилия =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_telvarion', 'Тэльварион', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_aelandir',  'Аэландир',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_morvenn',   'Морвенн',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_illateir',  'Иллатэйр',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_draenor',   'Драэнор',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_silvarin',  'Сильварин',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_kelador',   'Келадор',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_vainren',   'Вэйрэн',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_tarkvien',  'Тарквиэн',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_orelin',    'Орэлин',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_nimrael',   'Нимраэль',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_elandor',   'Эландор',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_gwindar',   'Гвиндар',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_braenn',    'Браэнн',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_korvel',    'Корвэль',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_halvari',   'Хальвари',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_dornvail',  'Дорнвэйл',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_ashtaren',  'Аштарэн',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_lirven',    'Лирвэн',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_seiran',    'Сэйран',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_rovaniel',  'Рованиэль',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_tiieldor',  'Тиэльдор',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_morgael',   'Моргаэль',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_veldarin',  'Вэлдарин',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_anvel',     'Анвэль',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_karvell',   'Карвэлл',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_zeirin',    'Зэйрин',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_ivel',      'Ивэль',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_neilor',    'Нэйлор',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='surname'), 'surname_yuvelin',   'Ювэлин',     1, NULL);

-- ===== Класс =====
INSERT INTO prop_values (prop_id, val_key, text) VALUES
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_warrior',     'Воин'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_mercenary',   'Наёмник'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_rogue',       'Плут'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_hunter',      'Охотник'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_cleric',      'Жрец'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_alchemist',   'Алхимик'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_merchant',    'Торговец'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_mage',        'Маг'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_ranger',      'Следопыт'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_bard',        'Бард'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_scholar',     'Учёный'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_craftsman',   'Ремесленник'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_runesmith',   'Рунный кузнец'),
((SELECT prop_id FROM properties WHERE prop_key='class'), 'class_blade_dancer','Клинковая плясунья');
--#endregion

--#region ===== ВНЕШНИЙ ВИД =====

-- ===== Рост =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='height'), 'h_50', '50', 1, 'race=dwarf'),
((SELECT prop_id FROM properties WHERE prop_key='height'), 'h_100', '100', 1, 'race=dwarf,gender=female,race=gnom'),
((SELECT prop_id FROM properties WHERE prop_key='height'), 'h_130', '130', 1, 'race=dwarf,gender=female'),
((SELECT prop_id FROM properties WHERE prop_key='height'), 'h_170', '170', 1, 'race=human,race=elf'),
((SELECT prop_id FROM properties WHERE prop_key='height'), 'h_185', '185', 1, 'race=human,gender=male,race=elf'),
((SELECT prop_id FROM properties WHERE prop_key='height'), 'h_200', '200', 1, 'race=human,gender=male,race=elf'),
((SELECT prop_id FROM properties WHERE prop_key='height'), 'h_250', '250', 1, 'race=human,gender=male,race=elf,race=orc');

-- ===== Вес ===== (автоматически)

-- ===== Телосложение =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='build'), 'slim',   'Худощавое', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='build'), 'normal', 'Обычное',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='build'), 'stocky', 'Крепкое',   1, NULL);

-- ===== Цвет кожи =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='skin_tone'), 'skin_pale',      'Бледный',    1, 'race=elf'),
((SELECT prop_id FROM properties WHERE prop_key='skin_tone'), 'skin_porcelain', 'Фарфоровый', 1, 'race=elf'),
((SELECT prop_id FROM properties WHERE prop_key='skin_tone'), 'skin_light',     'Светлый',    1, 'race=elf'),
((SELECT prop_id FROM properties WHERE prop_key='skin_tone'), 'skin_warm',      'Тёплый',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='skin_tone'), 'skin_ruddy',     'Румяный',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='skin_tone'), 'skin_olive',     'Оливковый',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='skin_tone'), 'skin_honey',     'Медовый',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='skin_tone'), 'skin_tan',       'Смуглый',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='skin_tone'), 'skin_sun',       'Загорелый',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='skin_tone'), 'skin_bronze',    'Бронзовый',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='skin_tone'), 'skin_dark',      'Тёмный',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='skin_tone'), 'skin_ash',       'Пепельный',  1, 'race=elf');

-- ===== Цвет волос =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='hair_color'), 'silver', 'Серебристый', 1, 'race=elf,origin=noble'),
((SELECT prop_id FROM properties WHERE prop_key='hair_color'), 'blond',  'Белокурый',   1, 'race=human,race=elf,origin=noble'),
((SELECT prop_id FROM properties WHERE prop_key='hair_color'), 'red',    'Рыжий',       1, 'race=human,race=dwarf,origin=commoner'),
((SELECT prop_id FROM properties WHERE prop_key='hair_color'), 'black',  'Чёрный',      1, 'race=human,race=dwarf');

-- ===== Тип волос =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='hair_type'), 'hair_type_straight', 'Прямые',         1, 'race=elf'),
((SELECT prop_id FROM properties WHERE prop_key='hair_type'), 'hair_type_wavy',     'Волнистые',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_type'), 'hair_type_curly',    'Кудрявые',       1, 'race=dwarf'),
((SELECT prop_id FROM properties WHERE prop_key='hair_type'), 'hair_type_locks',    'Крупные локоны', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_type'), 'hair_type_coils',    'Мелкие кудри',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_type'), 'hair_type_coarse',   'Жёсткие',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_type'), 'hair_type_soft',     'Мягкие',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_type'), 'hair_type_thick',    'Густые',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_type'), 'hair_type_thin',     'Тонкие',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_type'), 'hair_type_wild',     'Непослушные',    1, 'race=orc');

-- ===== Длина волос =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='hair_length'), 'hair_len_shaved', 'Бритая голова', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_length'), 'hair_len_buzz',   'Под ноль',      1, 'race=orc'),
((SELECT prop_id FROM properties WHERE prop_key='hair_length'), 'hair_len_short',  'Короткие',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_length'), 'hair_len_medium', 'Средние',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_length'), 'hair_len_shoulder','До плеч',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_length'), 'hair_len_long',   'Длинные',       1, 'race=elf'),
((SELECT prop_id FROM properties WHERE prop_key='hair_length'), 'hair_len_blades', 'До лопаток',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_length'), 'hair_len_waist',  'До пояса',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_length'), 'hair_len_verylong','Очень длинные',1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='hair_length'), 'hair_len_knees',  'До колен',      1, NULL);

-- ===== Стиль одежды =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='look_style'), 'style_plain',      'Простая',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='look_style'), 'style_travel',     'Дорожная',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='look_style'), 'style_worn',       'Потрёпанная',   1, 'origin=artisan'),
((SELECT prop_id FROM properties WHERE prop_key='look_style'), 'style_dapper',     'Щёгольская',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='look_style'), 'style_ascetic',    'Аскетичная',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='look_style'), 'style_luxurious',  'Роскошная',     1, 'origin=noble'),
((SELECT prop_id FROM properties WHERE prop_key='look_style'), 'style_work',       'Рабочая',       1, 'origin=artisan'),
((SELECT prop_id FROM properties WHERE prop_key='look_style'), 'style_ritual',     'Ритуальная',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='look_style'), 'style_military',   'Военная',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='look_style'), 'style_street',     'Уличная',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='look_style'), 'style_ceremonial', 'Церемониальная',1, 'origin=noble'),
((SELECT prop_id FROM properties WHERE prop_key='look_style'), 'style_sloppy',     'Небрежная',     1, NULL);

-- ===== Особенность =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_scar_brow',    'Шрам через бровь',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_scar_cheek',   'Шрам на щеке',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_scar_neck',    'Шрам на шее',             1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_tattoo_arm',   'Татуировка на предплечье',1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_tattoo_neck',  'Татуировка на шее',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_mole_lip',     'Родинка у губы',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_birthmark',    'Родимое пятно',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_burn_hand',    'Ожог на руке',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_broken_nose',  'Сломанный нос',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_missing_finger','Отсутствует палец',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_grey_streak',  'Седая прядь',             1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_heterochromia','Разные глаза',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_limp',         'Хромота',                 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_piercing',     'Пирсинг в ухе',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_palm_mark',    'Метка на ладони',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='feature'), 'feature_none',         'Без особых примет',       2, NULL);
--#endregion

--#region ===== ХАРАКТЕР ===== 
-- ===== Темперамент =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='temperament'), 'temp_sanguine',  'Сангвиник',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='temperament'), 'temp_choleric',  'Холерик',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='temperament'), 'temp_phlegmatic','Флегматик',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='temperament'), 'temp_melancholic','Меланхолик',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='temperament'), 'temp_irascible', 'Вспыльчивый',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='temperament'), 'temp_impassive', 'Невозмутимый', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='temperament'), 'temp_dreamy',    'Мечтательный', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='temperament'), 'temp_gambling',  'Азартный',     1, NULL);

-- ===== Главная добродетель =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_loyalty',      'Верность',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_honesty',      'Честность',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_courage',      'Смелость',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_kindness',     'Доброта',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_patience',     'Терпение',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_fairness',     'Справедливость',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_generosity',   'Щедрость',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_humility',     'Смирение',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_diligence',    'Трудолюбие',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_mercy',        'Милосердие',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_discipline',   'Дисциплина',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_curiosity',    'Любознательность',1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_optimism',     'Оптимизм',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_tact',         'Такт',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_responsibility','Ответственность',1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='virtue'), 'virtue_selflessness', 'Бескорыстие',     1, NULL);

-- ===== Главный порок =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_greed',        'Жадность',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_cowardice',    'Трусость',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_pride',        'Гордыня',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_irascibility', 'Вспыльчивость',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_envy',         'Зависть',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_deceit',       'Лживость',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_stubbornness', 'Упрямство',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_laziness',     'Лень',              1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_cruelty',      'Жестокость',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_vindictiveness','Мстительность',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_vanity',       'Тщеславие',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_suspicion',    'Подозрительность',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_irresponsibility','Безответственность',1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_recklessness', 'Безрассудство',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_arrogance',    'Высокомерие',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='flaw'), 'flaw_insecurity',   'Неуверенность',     1, NULL);

-- ===== Странность =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_fingers',     'Щёлкает пальцами',                 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_self_talk',   'Говорит сам с собой',              1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_steps',       'Считает шаги',                     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_stones',      'Коллекционирует мелкие камни',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_door',        'Не садится спиной к двери',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_hands',       'Ест только руками',                1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_chew',        'Постоянно что-то жуёт',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_hum',         'Поёт под нос',                     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_clothes',     'Поправляет одежду собеседнику',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_silence',     'Не выносит тишину и заполняет её', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_objects',     'Разговаривает с предметами',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_notes',       'Записывает всё в блокнот',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_smell',       'Нюхает еду перед едой',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_knife',       'Постоянно точит нож',              1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_ring',        'Крутит кольцо на пальце',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_apology',     'Извиняется перед мебелью',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_locks',       'Проверяет замки по три раза',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_tiptoe',      'Ходит на цыпочках',                1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_nicknames',   'Придумывает всем прозвища',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='quirk'), 'quirk_crows',       'Считает ворон',                    1, NULL);

-- ===== Страх =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_death',       'Смерть',               1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_fire',        'Огонь',                1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_water',       'Вода',                 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_dark',        'Темнота',              1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_heights',     'Высота',               1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_crowd',       'Толпа',                1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_loneliness',  'Одиночество',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_spiders',     'Пауки',                1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_snakes',      'Змеи',                 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_blood',       'Кровь',                1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_betrayal',    'Предательство',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_loss',        'Потеря близких',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_madness',     'Безумие',              1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_closed',      'Замкнутые пространства',1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_open',        'Открытые пространства', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_silence',     'Тишина',               1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_noise',       'Громкие звуки',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='fear'), 'fear_age',         'Старость',             1, NULL);

-- ===== Отношение к незнакомцам =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='trust'), 'trust_open',      'Открытый',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='trust'), 'trust_friendly',  'Дружелюбный',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='trust'), 'trust_wary',      'Настороженный', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='trust'), 'trust_distrust',  'Недоверчивый',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='trust'), 'trust_hostile',   'Враждебный',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='trust'), 'trust_indifferent','Равнодушный',  1, NULL);

-- ===== Мироощущение =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'wv_altruist',    'Альтруист',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'wv_benevolent',  'Доброжелательный',1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'wv_neutral',     'Нейтральный', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'wv_pragmatic',   'Прагматик',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'wv_egoist',      'Эгоист',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'wv_cynic',       'Циник',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'wv_cruel',       'Жестокий',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'wv_nihilist',    'Нигилист',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'wv_fanatic',     'Фанатик',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='worldview'), 'wv_hedonist',    'Гедонист',    1, NULL);
--#endregion

--#region ===== НАВЫКИ =====
-- ===== Основное ремесло =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_smith',      'Кузнец',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_weaponsmith','Оружейник',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_carpenter',  'Плотник',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_mason',      'Каменщик',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_potter',     'Гончар',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_weaver',     'Ткач',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_tanner',     'Кожевник',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_jeweler',    'Ювелир',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_baker',      'Пекарь',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_brewer',     'Пивовар',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_butcher',    'Мясник',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_herbalist',  'Травник',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_healer',     'Лекарь',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_scribe',     'Писарь',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_cartographer','Картограф',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_merchant',   'Торговец',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_sailor',     'Моряк',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_fisher',     'Рыбак',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_hunter',     'Охотник',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_shepherd',   'Пастух',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_farmer',     'Земледелец',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_miner',      'Рудокоп',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_carter',     'Возчик',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_servant',    'Слуга',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_singer',     'Певец',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession'), 'prof_teacher',    'Учитель',       1, NULL);

-- ===== Уровень владения ремеслом =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='profession_lvl'), 'lvl_apprentice', 'Ученик',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession_lvl'), 'lvl_journeyman', 'Подмастерье',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession_lvl'), 'lvl_craftsman',  'Ремесленник',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession_lvl'), 'lvl_master',     'Мастер',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='profession_lvl'), 'lvl_renowned',   'Признанный мастер',1, NULL);

-- ===== Стиль боя =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_none',        'Не владеет оружием',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_sword_shield','Меч и щит',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_greatsword',  'Двуручный меч',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_dual_blades', 'Парные клинки',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_dagger',      'Кинжал и скрытность', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_spear',       'Копьё',               1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_axe',         'Топор',               1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_bow',         'Лук',                 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_crossbow',    'Арбалет',             1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_sling',       'Праща',               1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_fists',       'Кулачный бой',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_staff',       'Посох',               1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_mounted',     'Верхом с копьём',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_throwing',    'Метательные ножи',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='combat_style'), 'combat_evasion',     'Уклонение и бегство', 1, NULL);

-- ===== Магия =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_none',        'Не владеет магией', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_spark',       'Слабая искра',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_household',   'Бытовые чары',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_elemental',   'Стихийная магия',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_healing',     'Целительство',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_illusion',    'Иллюзии',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_necromancy',  'Некромантия',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_summoning',   'Призыв',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_curses',      'Проклятия',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_seer',        'Ясновидение',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_nature',      'Природная магия',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_runes',       'Рунная магия',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_blood',       'Кровавая магия',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='magic'), 'magic_combat',      'Боевая магия',     1, NULL);
--#endregion

--#region ===== БИОГРАФИЯ =====
-- ===== Детство =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_happy',     'Счастливое',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_carefree',  'Безоблачное',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_hungry',    'Голодное',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_poor',      'Бедное',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_craft',     'Ремесленное',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_nomad',     'Кочевое',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_orphan',    'Сиротское',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_street',    'Уличное',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_noble',     'Дворянское',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_village',   'Деревенское',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_cold',      'Холодное',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_lonely',    'Одинокое',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_sheltered', 'Ограждённое от мира',1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='childhood'), 'child_harsh',     'Суровое',           1, NULL);

-- ===== Переломное событие =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_war',          'Война',                1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_fire',         'Пожар',                1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_family_loss',  'Потеря семьи',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_betrayal',     'Предательство друга',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_exile',        'Изгнание из дома',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_mentor_death', 'Смерть наставника',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_revelation',   'Раскрытие тайны',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_accident',     'Несчастный случай',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_miracle',      'Встреча с чудом',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_escape',       'Побег',                1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_debt',         'Крупный долг',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_robbery',      'Ограбление',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_rescue',       'Спасение чужой жизни', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_killing',      'Убийство',             1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_captivity',    'Плен',                 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_journey',      'Дальнее путешествие',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_artifact',     'Находка артефакта',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='key_event'), 'event_illness',      'Тяжёлая болезнь',      1, NULL);

-- ===== Тайна =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_birth',       'Незаконное происхождение', 1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_murder',      'Убийство в прошлом',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_theft',       'Кража',                    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_betrayal',    'Предательство',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_enemy_ties',  'Связь с врагом',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_forbidden',   'Запретная магия',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_debt',        'Невыплаченный долг',       1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_false_name',  'Поддельное имя',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_illness',     'Скрытая болезнь',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_gift',        'Скрытый дар',              1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_memory',      'Потерянная память',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_dark_deal',   'Сделка с тёмными силами',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_family',      'Скрытая семья',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_spy',         'Шпионаж',                  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_cowardice',   'Трусость на войне',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='secret'), 'secret_crime',       'Незакрытое преступление',  1, NULL);
--#endregion

--#region ===== МОТИВЫ И ЦЕЛИ =====
-- ===== Текущая цель =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_job',       'Найти работу',               1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_money',     'Заработать денег',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_debt',      'Расплатиться с долгом',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_missing',   'Найти пропавшего родственника',1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_city',      'Добраться до дальнего города',1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_gear',      'Купить новое снаряжение',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_heal',      'Вылечиться от болезни',      1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_shelter',   'Найти кров на зиму',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_trust',     'Заслужить чужое доверие',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_errand',    'Выполнить чужое поручение',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_teacher',   'Найти учителя',              1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_info',      'Собрать сведения',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_revenge',   'Отомстить обидчику',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_hide',      'Скрыться от преследования',  1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='short_term_goal'), 'goal_save',      'Накопить на мечту',          1, NULL);

-- ===== Мечта =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_business', 'Собственное дело',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_home',     'Свой дом',             1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_family',   'Семья и дети',         1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_fame',     'Слава и признание',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_wealth',   'Богатство',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_peace',    'Покой',                1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_knowledge','Знания и открытия',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_power',    'Власть',               1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_justice',  'Справедливость в мире',1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_return',   'Возвращение домой',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_mastery',  'Достичь мастерства',   1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_freedom',  'Свобода',              1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_revenge',  'Месть',                1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='long_term_dream'), 'dream_immortality','Бессмертие',         1, NULL);

-- ===== Мотивация =====
INSERT INTO prop_values (prop_id, val_key, text, weight, tags) VALUES
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_fear',     'Страх',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_duty',     'Долг',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_revenge',  'Месть',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_love',     'Любовь',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_profit',   'Выгода',          1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_loyalty',  'Верность',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_curiosity','Любопытство',     1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_faith',    'Вера',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_pride',    'Гордость',        1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_guilt',    'Вина',            1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_thrill',   'Азарт',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_boredom',  'Скука',           1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_knowledge','Жажда знаний',    1, NULL),
((SELECT prop_id FROM properties WHERE prop_key='motivation'), 'motiv_protect',  'Защита близких',  1, NULL);
--#endregion