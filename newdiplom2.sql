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

-- Дамп данных таблицы newdiplom.access_list: ~4 rows (приблизительно)
/*!40000 ALTER TABLE `access_list` DISABLE KEYS */;
REPLACE INTO `access_list` (`id`, `access_name`) VALUES
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
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.dishes_in_order: ~51 rows (приблизительно)
/*!40000 ALTER TABLE `dishes_in_order` DISABLE KEYS */;
REPLACE INTO `dishes_in_order` (`id`, `dish_id`, `order_id`, `dish_count_in_order`) VALUES
	(82, 1, 62, 5),
	(83, 3, 62, 4),
	(84, 4, 62, 3),
	(85, 2, 62, 1),
	(86, 1, 63, 3),
	(87, 2, 63, 2),
	(88, 3, 63, 2),
	(89, 1, 64, 2),
	(90, 1, 65, 2),
	(91, 1, 66, 4),
	(92, 4, 66, 1),
	(93, 3, 66, 1),
	(94, 1, 67, 3),
	(95, 2, 67, 2),
	(96, 3, 68, 1),
	(97, 3, 69, 1),
	(98, 1, 70, 3),
	(99, 1, 71, 6),
	(100, 1, 72, 8),
	(101, 1, 73, 2),
	(102, 3, 74, 3),
	(103, 1, 75, 6),
	(104, 1, 76, 2),
	(105, 1, 77, 1),
	(106, 1, 78, 4),
	(107, 1, 79, 4),
	(108, 1, 80, 4),
	(109, 1, 81, 4),
	(110, 1, 82, 3),
	(111, 1, 83, 2),
	(112, 1, 84, 3),
	(113, 1, 85, 3),
	(114, 1, 86, 2),
	(115, 1, 87, 1),
	(116, 1, 88, 1),
	(117, 1, 89, 1),
	(118, 1, 74, 2),
	(119, 1, 90, 2),
	(120, 1, 91, 1),
	(121, 1, 92, 1),
	(122, 1, 93, 1),
	(123, 1, 94, 3),
	(124, 1, 95, 1),
	(125, 1, 96, 2),
	(126, 1, 97, 2),
	(127, 1, 98, 2),
	(128, 1, 99, 2),
	(129, 1, 100, 2),
	(130, 1, 101, 2),
	(131, 1, 102, 2),
	(132, 1, 103, 2);
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
REPLACE INTO `dishs` (`id`, `dish_name`, `dish_price`, `dish_sold`, `dish_type_id`, `dish_description`, `dish_image`) VALUES
	(1, 'Биг мак', 0000000100, 0, 1, '«Биг Мак» — гамбургер, предлагаемый компанией McDonald’s в своих заведениях. Он является одним из наиболее известных продуктов компании в мире, наряду с Quarter Pounder.', '../static/img/burgers.png'),
	(2, 'Биг тейсти', 0000000150, 0, 1, 'Это сандвич с большим, рубленым бифштексом из 100% говядины на большой булочке с кунжутом. Особенный вкус сандвичу придают три кусочка сыра «эмменталь», два ломтика помидора, свежий салат, лук и пикантный соус «Гриль».', '../static/img/bigteisti.png'),
	(3, 'Чизбургер', 0000000050, 0, 1, 'Чи́збургер — вид гамбургера с обязательным добавлением сыра. В дополнение к мясу чизбургер может иметь большое количество разнообразных приправ, например: кетчуп и майонез. Чизбургер часто подают вместе с картофелем фри, яичницей либо салатами.', '../static/img/cheesburger.png'),
	(4, 'Гамбургер', 0000000052, 0, 1, 'Га́мбургер — вид сандвича, состоящий из разрезанной пополам булочки и рубленой жареной котлеты. В дополнение к мясу гамбургер может иметь большое количество разнообразных наполнителей, например: кетчуп и майонез, дольку кабачка, листья салата, маринованный огурец, сырой или жареный лук, помидор.', '../static/img/hamburger.png');
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
REPLACE INTO `dish_types` (`id`, `dish_type_name`, `dish_type_img`, `dish_type_translit`) VALUES
	(1, 'Бургеры', '../static/img/burgers.png', 'Burgery'),
	(2, 'Салаты', '../static/img/salads.png', NULL),
	(3, 'Напитки', '../static/img/drinks.png', NULL),
	(4, 'Картошка', '../static/img/free.png', NULL),
	(5, 'Закуски', '../static/img/zakuski.png', NULL),
	(6, 'Роллы', '../static/img/rolls.png', NULL),
	(7, 'Десерты', '../static/img/deserts.png', NULL),
	(8, 'Новинки', '../static/img/new.png', NULL),
	(9, 'Дополнительно', '../static/img/more.png', NULL);
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
REPLACE INTO `ingredients` (`id`, `ingredient_name`, `ingredient_description`, `ingredient_calories`) VALUES
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
REPLACE INTO `ingredients_in_dish` (`id`, `dish_id`, `ingredient_id`, `weight`) VALUES
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
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.orders: ~42 rows (приблизительно)
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
REPLACE INTO `orders` (`id`, `order_date`, `order_price`, `order_status`, `order_executor`, `order_table`) VALUES
	(62, '2020-05-04 19:56:08', 1006, '9', 11, 1),
	(63, '2020-05-04 20:18:48', 700, '2', 11, 2),
	(64, '2020-05-04 20:41:25', 200, '2', 11, 1),
	(65, '2020-05-04 20:49:44', 200, '9', 11, 1),
	(66, '2020-05-04 21:04:15', 0, '0', 0, 0),
	(67, '2020-05-04 23:52:10', 600, '9', 11, 1),
	(68, '2020-05-04 23:55:12', 50, '9', 11, 1),
	(69, '2020-05-05 00:17:50', 0, '0', 0, 0),
	(70, '2020-05-05 00:53:27', 0, '0', 0, 0),
	(71, '2020-05-05 00:57:41', 0, '0', 0, 0),
	(72, '2020-05-05 01:00:20', 0, '0', 0, 0),
	(73, '2020-05-05 01:09:12', 200, '2', 11, 1),
	(74, '2020-05-05 01:12:20', 350, '1', 0, 1),
	(75, '2020-05-05 01:16:52', 600, '2', 11, 1),
	(76, '2020-05-05 01:26:46', 200, '2', 11, 1),
	(77, '2020-05-05 01:27:22', 100, '2', 11, 1),
	(78, '2020-05-05 01:29:55', 400, '2', 11, 1),
	(79, '2020-05-05 01:30:22', 400, '1', 0, 1),
	(80, '2020-05-05 01:31:34', 400, '1', 0, 1),
	(81, '2020-05-05 01:33:24', 400, '1', 0, 1),
	(82, '2020-05-05 01:34:30', 300, '1', 0, 1),
	(83, '2020-05-05 01:37:22', 200, '1', 0, 1),
	(84, '2020-05-05 01:38:25', 300, '1', 0, 1),
	(85, '2020-05-05 01:45:24', 300, '1', 0, 1),
	(86, '2020-05-05 01:46:58', 200, '1', 0, 1),
	(87, '2020-05-05 01:48:10', 100, '1', 0, 1),
	(88, '2020-05-05 01:48:52', 100, '1', 0, 1),
	(89, '2020-05-05 01:49:29', 100, '1', 0, 1),
	(90, '2020-05-05 01:51:39', 200, '1', 0, 1),
	(91, '2020-05-05 01:53:16', 100, '1', 0, 1),
	(92, '2020-05-05 01:54:33', 100, '1', 0, 1),
	(93, '2020-05-05 01:55:02', 100, '1', 0, 1),
	(94, '2020-05-05 01:55:13', 300, '1', 0, 1),
	(95, '2020-05-05 01:56:09', 100, '1', 0, 1),
	(96, '2020-05-05 02:01:24', 200, '1', 0, 1),
	(97, '2020-05-05 02:02:37', 200, '1', 0, 1),
	(98, '2020-05-05 02:09:51', 200, '1', 0, 1),
	(99, '2020-05-05 02:10:30', 200, '1', 0, 1),
	(100, '2020-05-05 02:10:51', 200, '1', 0, 1),
	(101, '2020-05-05 02:11:12', 200, '1', 0, 1),
	(102, '2020-05-05 02:11:41', 200, '1', 0, 1),
	(103, '2020-05-05 02:11:51', 200, '1', 0, 1);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.tables
CREATE TABLE IF NOT EXISTS `tables` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.tables: ~3 rows (приблизительно)
/*!40000 ALTER TABLE `tables` DISABLE KEYS */;
REPLACE INTO `tables` (`id`) VALUES
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.users: ~9 rows (приблизительно)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
REPLACE INTO `users` (`id`, `user_name`, `user_img`, `user_phone`, `user_password`) VALUES
	(6, '123123', 'default.png', '79196413562', '259138cadddfa6d5d75f8d53ec169c0a'),
	(7, 'kirx', 'default.png', '919', '46f94c8de14fb36680850768ff1b7f2a'),
	(11, 'Официант', 'default.png', '1111111111', '46f94c8de14fb36680850768ff1b7f2a'),
	(12, 'kirx', 'default.png', '919642', '46f94c8de14fb36680850768ff1b7f2a'),
	(13, 'Ирина', 'default.png', '89991551737', 'e807f1fcf82d132f9bb018ca6738a19f'),
	(14, 'kirx', 'default.png', '123', '46f94c8de14fb36680850768ff1b7f2a'),
	(16, 'yyyy', 'default.png', '1234', '46f94c8de14fb36680850768ff1b7f2a'),
	(20, '123qwe', 'default.png', '84984623', '46f94c8de14fb36680850768ff1b7f2a'),
	(21, 'Клиент', 'default.png', '2222222222', '46f94c8de14fb36680850768ff1b7f2a');
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

-- Дамп данных таблицы newdiplom.users_accesses: ~9 rows (приблизительно)
/*!40000 ALTER TABLE `users_accesses` DISABLE KEYS */;
REPLACE INTO `users_accesses` (`user_id`, `access_id`) VALUES
	(7, 1),
	(6, 2),
	(11, 2),
	(12, 1),
	(13, 1),
	(14, 1),
	(16, 1),
	(20, 1),
	(21, 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.user_orders: ~39 rows (приблизительно)
/*!40000 ALTER TABLE `user_orders` DISABLE KEYS */;
REPLACE INTO `user_orders` (`id`, `order_id`, `user_id`) VALUES
	(33, 62, 11),
	(34, 63, 11),
	(35, 64, 7),
	(36, 65, 11),
	(37, 66, 7),
	(38, 67, 11),
	(39, 68, 11),
	(43, 72, 20),
	(44, 73, 21),
	(45, 74, 11),
	(46, 75, 21),
	(47, 76, 21),
	(48, 77, 21),
	(49, 78, 21),
	(50, 79, 21),
	(51, 80, 21),
	(52, 81, 21),
	(53, 82, 21),
	(54, 83, 21),
	(55, 84, 21),
	(56, 85, 21),
	(57, 86, 21),
	(58, 87, 21),
	(59, 88, 21),
	(60, 89, 21),
	(61, 90, 11),
	(62, 91, 11),
	(63, 92, 21),
	(64, 93, 21),
	(65, 94, 11),
	(66, 95, 11),
	(67, 96, 11),
	(68, 97, 11),
	(69, 98, 21),
	(70, 99, 21),
	(71, 100, 21),
	(72, 101, 21),
	(73, 102, 21),
	(74, 103, 11);
/*!40000 ALTER TABLE `user_orders` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
