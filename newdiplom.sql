-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               10.3.13-MariaDB-log - mariadb.org binary distribution
-- Операционная система:         Win64
-- HeidiSQL Версия:              10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Дамп структуры базы данных newdiplom
CREATE DATABASE IF NOT EXISTS `newdiplom` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `newdiplom`;

-- Дамп структуры для таблица newdiplom.access_list
CREATE TABLE IF NOT EXISTS `access_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `access_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.access_list: ~0 rows (приблизительно)
/*!40000 ALTER TABLE `access_list` DISABLE KEYS */;
INSERT IGNORE INTO `access_list` (`id`, `access_name`) VALUES
	(1, 'Клиент'),
	(2, 'Официант'),
	(3, 'Кассир'),
	(4, 'Администратор');
/*!40000 ALTER TABLE `access_list` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.dishes_in_order
CREATE TABLE IF NOT EXISTS `dishes_in_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dish_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `dish_count_in_order` int(11) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `FK_dishes_in_order_dishs` (`dish_id`),
  KEY `FK_dishes_in_order_orders` (`order_id`),
  CONSTRAINT `FK_dishes_in_order_dishs` FOREIGN KEY (`dish_id`) REFERENCES `dishs` (`id`),
  CONSTRAINT `FK_dishes_in_order_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.dishes_in_order: ~7 rows (приблизительно)
/*!40000 ALTER TABLE `dishes_in_order` DISABLE KEYS */;
INSERT IGNORE INTO `dishes_in_order` (`id`, `dish_id`, `order_id`, `dish_count_in_order`) VALUES
	(1, 1, 1, 5),
	(2, 2, 1, 4),
	(3, 3, 1, 3),
	(4, 4, 1, 2),
	(34, 2, 23, 1),
	(35, 4, 23, 4),
	(36, 1, 23, 2),
	(37, 3, 23, 1),
	(38, 1, 24, 1),
	(39, 3, 24, 1),
	(40, 1, 25, 2),
	(41, 3, 25, 1),
	(42, 4, 25, 1),
	(43, 2, 25, 1),
	(44, 2, 26, 11);
/*!40000 ALTER TABLE `dishes_in_order` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.dishs
CREATE TABLE IF NOT EXISTS `dishs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dish_name` varchar(155) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dish_price` int(10) unsigned zerofill NOT NULL DEFAULT 0000000000,
  `dish_sold` int(11) NOT NULL DEFAULT 0,
  `dish_type_id` int(11) NOT NULL,
  `dish_description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dish_image` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dish_type_id` (`dish_type_id`),
  CONSTRAINT `dishs_ibfk_1` FOREIGN KEY (`dish_type_id`) REFERENCES `dish_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.dishs: ~4 rows (приблизительно)
/*!40000 ALTER TABLE `dishs` DISABLE KEYS */;
INSERT IGNORE INTO `dishs` (`id`, `dish_name`, `dish_price`, `dish_sold`, `dish_type_id`, `dish_description`, `dish_image`) VALUES
	(1, 'Биг мак', 0000000100, 0, 1, '«Биг Мак» — гамбургер, предлагаемый компанией McDonald’s в своих заведениях. Он является одним из наиболее известных продуктов компании в мире, наряду с Quarter Pounder.', '../static/img/burgers.png'),
	(2, 'Биг тейсти', 0000000150, 0, 1, 'Это сандвич с большим, рубленым бифштексом из 100% говядины на большой булочке с кунжутом. Особенный вкус сандвичу придают три кусочка сыра «эмменталь», два ломтика помидора, свежий салат, лук и пикантный соус «Гриль».', '../static/img/burgers.png'),
	(3, 'Чизбургер', 0000000050, 0, 1, 'Чи́збургер — вид гамбургера с обязательным добавлением сыра. В дополнение к мясу чизбургер может иметь большое количество разнообразных приправ, например: кетчуп и майонез. Чизбургер часто подают вместе с картофелем фри, яичницей либо салатами.', '../static/img/burgers.png'),
	(4, 'Гамбургер', 0000000052, 0, 1, 'Га́мбургер — вид сандвича, состоящий из разрезанной пополам булочки и рубленой жареной котлеты. В дополнение к мясу гамбургер может иметь большое количество разнообразных наполнителей, например: кетчуп и майонез, дольку кабачка, листья салата, маринованный огурец, сырой или жареный лук, помидор.', '../static/img/burgers.png');
/*!40000 ALTER TABLE `dishs` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.dish_types
CREATE TABLE IF NOT EXISTS `dish_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dish_type_name` text COLLATE utf8mb4_unicode_ci DEFAULT 'NULL',
  `dish_type_img` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dish_type_translit` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.dish_types: ~9 rows (приблизительно)
/*!40000 ALTER TABLE `dish_types` DISABLE KEYS */;
INSERT IGNORE INTO `dish_types` (`id`, `dish_type_name`, `dish_type_img`, `dish_type_translit`) VALUES
	(1, 'Бургеры', NULL, 'Burgery'),
	(2, 'Салаты', NULL, NULL),
	(3, 'Напитки', NULL, NULL),
	(4, 'Картошка', NULL, NULL),
	(5, 'Закуски', NULL, NULL),
	(6, 'Роллы', NULL, NULL),
	(7, 'Десерты', NULL, NULL),
	(8, 'Новинки', NULL, NULL),
	(9, 'Дополнительно', NULL, NULL);
/*!40000 ALTER TABLE `dish_types` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.ingredients
CREATE TABLE IF NOT EXISTS `ingredients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ingredient_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ingredient_description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ingredient_calories` int(10) unsigned zerofill NOT NULL DEFAULT 0000000000,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.ingredients: ~12 rows (приблизительно)
/*!40000 ALTER TABLE `ingredients` DISABLE KEYS */;
INSERT IGNORE INTO `ingredients` (`id`, `ingredient_name`, `ingredient_description`, `ingredient_calories`) VALUES
	(1, 'Листья салата Айсберг', 'Салат Айсберг Салат Айсберг – овощная культура, относящаяся к кочанным салатам, имеет светло-зелёные листья, завернутые в небольшие, не очень плотные кочаны, сочные и хрустящие на вкус.', 0000000014),
	(2, 'Королевские креветки', 'Королевские креветки – это не определенный вид ракообразных, а общее название больших по размеру креветок.', 0000000087),
	(3, 'Панировочные сухари', 'Панировочные сухари — сухарная крошка из пшеничного хлеба, используемая для обсыпки обжариваемых изделий из мяса, рыбы и овощей.', 0000000395),
	(4, 'Сыр пармезан', 'Пармеза́н — итальянский сорт твёрдого сыра долгого созревания.', 0000000431),
	(5, 'Чесночные сухарики', 'Сухарики с ароматом чеснока.', 0000000239),
	(6, 'Соус Цезарь', 'Соус с именем великого полководца.', 0000000361),
	(7, 'Котлета из говядины', 'Сочная котлета из 100% говядины.', 0000000260),
	(8, 'Плавленный сыр', NULL, 0000000148),
	(9, 'Сыр Чеддер', 'Чеддер — популярный английский сыр жирностью от 35 до 45%.', 0000000402),
	(10, 'Листовой салат', 'Лату́к посевной, или Сала́т латук — вид однолетних травянистых растений рода Латук семейства Астровые.', 0000000015),
	(11, 'Сырный соус', 'Всеми любимый сырный соус.', 0000000356),
	(12, 'Булочка для бургера', NULL, 0000000272);
/*!40000 ALTER TABLE `ingredients` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.ingredients_in_dish
CREATE TABLE IF NOT EXISTS `ingredients_in_dish` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dish_id` int(11) DEFAULT NULL,
  `ingredient_id` int(11) DEFAULT NULL,
  `weight` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ingredients_in_dish_dishs` (`dish_id`),
  KEY `FK_ingredients_in_dish_ingredients` (`ingredient_id`),
  CONSTRAINT `FK_ingredients_in_dish_dishs` FOREIGN KEY (`dish_id`) REFERENCES `dishs` (`id`),
  CONSTRAINT `FK_ingredients_in_dish_ingredients` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.ingredients_in_dish: ~22 rows (приблизительно)
/*!40000 ALTER TABLE `ingredients_in_dish` DISABLE KEYS */;
INSERT IGNORE INTO `ingredients_in_dish` (`id`, `dish_id`, `ingredient_id`, `weight`) VALUES
	(1, 4, 1, 10),
	(2, 4, 2, 10),
	(3, 4, 3, 10),
	(4, 4, 4, 10),
	(5, 4, 5, 10),
	(6, 4, 6, 10),
	(7, 1, 7, 100),
	(8, 1, 9, 10),
	(9, 1, 10, 10),
	(10, 1, 11, 10),
	(11, 1, 12, 10),
	(12, 2, 7, 100),
	(13, 2, 9, 10),
	(14, 2, 10, 10),
	(15, 2, 11, 10),
	(16, 2, 12, 10),
	(17, 3, 7, 100),
	(18, 3, 9, 10),
	(19, 3, 10, 10),
	(20, 3, 11, 10),
	(21, 3, 12, 10),
	(22, 1, 1, 10);
/*!40000 ALTER TABLE `ingredients_in_dish` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.orders
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_date` datetime DEFAULT current_timestamp(),
  `order_price` int(11) DEFAULT 0,
  `order_status` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `order_executor` int(11) DEFAULT NULL,
  `order_table` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_orders_users` (`order_executor`),
  KEY `order_table` (`order_table`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.orders: ~6 rows (приблизительно)
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT IGNORE INTO `orders` (`id`, `order_date`, `order_price`, `order_status`, `order_executor`, `order_table`) VALUES
	(1, '2020-04-19 14:50:25', 352, '1', NULL, 3),
	(2, '2020-04-19 14:50:25', 352, '1', NULL, 3),
	(3, '2020-04-19 14:50:25', 352, '1', NULL, 3),
	(4, '2020-04-19 14:50:25', 352, '1', NULL, 3),
	(5, '2020-05-01 16:13:13', 352, '1', NULL, 3),
	(6, '2020-05-01 16:17:44', 352, '1', NULL, 3),
	(23, '2020-05-01 17:16:35', 352, '1', 0, 1),
	(24, '2020-05-02 18:22:56', 150, '1', 0, 3),
	(25, '2020-05-02 18:23:54', 352, '1', 0, 2),
	(26, '2020-05-02 18:24:32', 1650, '1', 0, 2);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.tables
CREATE TABLE IF NOT EXISTS `tables` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.tables: ~2 rows (приблизительно)
/*!40000 ALTER TABLE `tables` DISABLE KEYS */;
INSERT IGNORE INTO `tables` (`id`) VALUES
	(1),
	(2),
	(3);
/*!40000 ALTER TABLE `tables` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_img` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_password` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.users: ~3 rows (приблизительно)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT IGNORE INTO `users` (`id`, `user_name`, `user_img`, `user_phone`, `user_password`) VALUES
	(1, 'Егор', 'adm.jpg', '79196413561', '123qwe'),
	(6, '123123', 'default.png', '79196413562', '259138cadddfa6d5d75f8d53ec169c0a'),
	(7, 'kirx', 'default.png', '919', '46f94c8de14fb36680850768ff1b7f2a'),
	(11, 'kirxeg', 'default.png', '919641', '46f94c8de14fb36680850768ff1b7f2a'),
	(12, 'kirx', 'default.png', '919642', '46f94c8de14fb36680850768ff1b7f2a');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.users_accesses
CREATE TABLE IF NOT EXISTS `users_accesses` (
  `user_id` int(11) NOT NULL,
  `access_id` int(11) NOT NULL,
  KEY `access_id` (`access_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `users_accesses_ibfk_1` FOREIGN KEY (`access_id`) REFERENCES `access_list` (`id`),
  CONSTRAINT `users_accesses_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.users_accesses: ~0 rows (приблизительно)
/*!40000 ALTER TABLE `users_accesses` DISABLE KEYS */;
INSERT IGNORE INTO `users_accesses` (`user_id`, `access_id`) VALUES
	(7, 1),
	(1, 4),
	(6, 2),
	(11, 2),
	(12, 1);
/*!40000 ALTER TABLE `users_accesses` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.user_orders
CREATE TABLE IF NOT EXISTS `user_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK__orders` (`order_id`),
  KEY `FK__users` (`user_id`),
  CONSTRAINT `FK__orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `FK__users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.user_orders: ~5 rows (приблизительно)
/*!40000 ALTER TABLE `user_orders` DISABLE KEYS */;
INSERT IGNORE INTO `user_orders` (`id`, `order_id`, `user_id`) VALUES
	(1, 1, 1),
	(2, 2, 1),
	(3, 3, 1),
	(4, 4, 1),
	(15, 23, 7),
	(16, 24, 7),
	(17, 25, 7),
	(18, 26, 7);
/*!40000 ALTER TABLE `user_orders` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
