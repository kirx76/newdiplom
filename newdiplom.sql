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
  `id` int(11) NOT NULL,
  `access_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.access_list: ~5 rows (приблизительно)
/*!40000 ALTER TABLE `access_list` DISABLE KEYS */;
REPLACE INTO `access_list` (`id`, `access_name`) VALUES
	(1, 'Клиент'),
	(2, 'Официант'),
	(3, 'Кассир'),
	(4, 'Администратор'),
	(0, 'Заблокирован');
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
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.dishes_in_order: ~19 rows (приблизительно)
/*!40000 ALTER TABLE `dishes_in_order` DISABLE KEYS */;
REPLACE INTO `dishes_in_order` (`id`, `dish_id`, `order_id`, `dish_count_in_order`) VALUES
	(143, 1, 109, 4),
	(144, 1, 110, 4),
	(145, 1, 111, 1),
	(146, 2, 112, 1),
	(147, 2, 113, 1),
	(148, 3, 114, 2),
	(151, 2, 115, 2),
	(152, 1, 114, 4),
	(155, 1, 116, 6),
	(157, 1, 117, 3),
	(158, 4, 115, 3),
	(159, 1, 115, 4),
	(160, 1, 119, 3),
	(161, 1, 120, 13),
	(162, 1, 121, 1),
	(163, 1, 122, 2),
	(164, 1, 123, 2),
	(165, 1, 124, 4),
	(166, 1, 125, 3),
	(168, 1, 126, 3),
	(169, 1, 127, 3),
	(170, 2, 127, 2),
	(171, 3, 127, 1),
	(172, 1, 128, 2),
	(173, 1, 129, 4),
	(174, 1, 130, 1),
	(175, 1, 131, 1),
	(176, 1, 132, 5),
	(177, 2, 132, 2),
	(178, 3, 132, 3),
	(179, 4, 132, 3),
	(180, 1, 133, 4),
	(181, 2, 133, 2),
	(183, 4, 133, 2),
	(184, 1, 134, 2),
	(185, 1, 135, 2),
	(186, 1, 136, 4),
	(187, 1, 137, 4),
	(188, 1, 138, 2),
	(189, 1, 139, 3),
	(190, 2, 140, 2),
	(191, 1, 141, 2),
	(192, 2, 142, 2),
	(193, 3, 142, 2),
	(194, 2, 143, 2),
	(195, 3, 144, 2),
	(196, 1, 145, 1),
	(197, 1, 146, 4),
	(198, 1, 147, 3),
	(199, 1, 148, 2);
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.dish_types: ~9 rows (приблизительно)
/*!40000 ALTER TABLE `dish_types` DISABLE KEYS */;
REPLACE INTO `dish_types` (`id`, `dish_type_name`, `dish_type_img`, `dish_type_translit`) VALUES
	(1, 'Бургеры', '../static/img/burgers.png', 'Burgery'),
	(2, 'Салаты', '../static/img/salads.png', 'Salaty'),
	(3, 'Напитки', '../static/img/drinks.png', 'Napitki'),
	(4, 'Картошка', '../static/img/free.png', 'Kartoshka'),
	(5, 'Закуски', '../static/img/zakuski.png', 'Zakuski'),
	(6, 'Роллы', '../static/img/rolls.png', 'Rolly'),
	(7, 'Десерты', '../static/img/deserts.png', 'Deserty'),
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.ingredients: ~14 rows (приблизительно)
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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.ingredients_in_dish: ~25 rows (приблизительно)
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
  `order_status` int(11) DEFAULT NULL,
  `order_executor` int(11) DEFAULT NULL,
  `order_table` int(11) DEFAULT NULL,
  `order_pay_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_orders_users` (`order_executor`),
  KEY `order_table` (`order_table`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.orders: ~17 rows (приблизительно)
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
REPLACE INTO `orders` (`id`, `order_date`, `order_price`, `order_status`, `order_executor`, `order_table`, `order_pay_type`) VALUES
	(109, '2020-05-06 18:02:03', 400, 3, 11, 1, 0),
	(110, '2020-05-06 18:03:32', 400, 3, 11, 1, 0),
	(111, '2020-05-06 18:03:56', 100, 3, 11, 1, 0),
	(112, '2020-05-06 18:05:21', 150, 3, 11, 1, 0),
	(113, '2020-05-06 18:05:56', 150, 3, 11, 1, 0),
	(114, '2020-05-06 18:54:34', 500, 3, 11, 1, 0),
	(115, '2020-05-06 19:19:00', 856, 2, 11, 1, 0),
	(116, '2020-05-07 00:13:51', 600, 3, 11, 1, 0),
	(117, '2020-05-07 20:13:45', 300, 3, 11, 1, 0),
	(118, '2020-05-07 23:31:38', 0, 0, 0, 0, 0),
	(119, '2020-05-09 11:43:28', 300, 2, 11, 1, 0),
	(120, '2020-05-09 11:43:58', 1300, 2, 11, 1, 0),
	(121, '2020-05-09 15:05:44', 0, 0, 0, 0, 0),
	(122, '2020-05-09 16:36:50', 200, 2, 11, 1, 0),
	(123, '2020-05-09 16:42:11', 200, 2, 11, 1, 0),
	(124, '2020-05-09 16:42:57', 400, 2, 11, 2, 0),
	(125, '2020-05-09 16:59:52', 300, 2, 11, 1, 0),
	(126, '2020-05-09 17:09:56', 300, 2, 11, 1, 0),
	(127, '2020-05-10 11:40:49', 650, 2, 0, 1, 0),
	(128, '2020-05-10 11:58:26', 200, 2, 11, 1, 0),
	(129, '2020-05-10 12:09:38', 400, 2, 11, 1, 0),
	(130, '2020-05-10 12:52:32', 100, 2, 11, 1, 0),
	(131, '2020-05-10 12:52:52', 100, 2, 11, 1, 0),
	(132, '2020-05-10 13:02:36', 1106, 2, 11, 1, 0),
	(133, '2020-05-10 13:05:40', 804, 2, 11, 10, 0),
	(134, '2020-05-10 14:34:07', 200, 2, 11, 1, 0),
	(135, '2020-05-10 14:34:53', 200, 2, 11, 1, 0),
	(136, '2020-05-10 14:39:11', 400, 2, 11, 1, 0),
	(137, '2020-05-10 14:40:04', 400, 2, 11, 1, 0),
	(138, '2020-05-10 14:42:24', 200, 2, 11, 1, 2),
	(139, '2020-05-10 14:44:12', 300, 1, 0, 1, 2),
	(140, '2020-05-10 14:44:29', 300, 1, 0, 1, 1),
	(141, '2020-05-10 14:51:58', 200, 1, 0, 1, 1),
	(142, '2020-05-10 14:52:33', 400, 1, 0, 1, 2),
	(143, '2020-05-10 14:53:19', 300, 1, 0, 1, 2),
	(144, '2020-05-10 14:54:11', 100, 2, 11, 1, 0),
	(145, '2020-05-10 14:54:47', 100, 2, 11, 1, 0),
	(146, '2020-05-10 15:27:59', 400, 3, 11, 1, 0),
	(147, '2020-05-10 16:46:22', 300, 2, 0, 1, 0),
	(148, '2020-05-10 16:49:12', 200, 2, 0, 1, 0);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.order_pay_types
CREATE TABLE IF NOT EXISTS `order_pay_types` (
  `order_pay_type_id` int(11) NOT NULL,
  `order_pay_type_name` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.order_pay_types: ~0 rows (приблизительно)
/*!40000 ALTER TABLE `order_pay_types` DISABLE KEYS */;
REPLACE INTO `order_pay_types` (`order_pay_type_id`, `order_pay_type_name`) VALUES
	(0, 'Онлайн оплата'),
	(1, 'Оплата картой'),
	(2, 'Оплата наличными');
/*!40000 ALTER TABLE `order_pay_types` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.order_status_list
CREATE TABLE IF NOT EXISTS `order_status_list` (
  `order_status_id` int(11) NOT NULL,
  `order_status_name` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.order_status_list: ~4 rows (приблизительно)
/*!40000 ALTER TABLE `order_status_list` DISABLE KEYS */;
REPLACE INTO `order_status_list` (`order_status_id`, `order_status_name`) VALUES
	(0, 'В корзине'),
	(1, 'Принят в обработку'),
	(2, 'Готовится'),
	(3, 'Завершен');
/*!40000 ALTER TABLE `order_status_list` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.tables
CREATE TABLE IF NOT EXISTS `tables` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.tables: ~10 rows (приблизительно)
/*!40000 ALTER TABLE `tables` DISABLE KEYS */;
REPLACE INTO `tables` (`id`) VALUES
	(1),
	(2),
	(3),
	(4),
	(5),
	(6),
	(7),
	(8),
	(9),
	(10);
/*!40000 ALTER TABLE `tables` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_img` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_password` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.users: ~9 rows (приблизительно)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
REPLACE INTO `users` (`id`, `user_name`, `user_img`, `user_phone`, `user_password`) VALUES
	(6, '123123', 'default.png', '79196413562', '259138cadddfa6d5d75f8d53ec169c0a'),
	(7, 'kirx', 'default.png', '9999999999', '46f94c8de14fb36680850768ff1b7f2a'),
	(11, 'Официант', 'default.png', '1111111111', '46f94c8de14fb36680850768ff1b7f2a'),
	(12, 'kirx', 'default.png', '3333333333', '46f94c8de14fb36680850768ff1b7f2a'),
	(13, 'Ирина', 'default.png', '89991551737', 'e807f1fcf82d132f9bb018ca6738a19f'),
	(14, 'kirx', 'default.png', '123', '46f94c8de14fb36680850768ff1b7f2a'),
	(16, 'yyyy', 'default.png', '1234', '46f94c8de14fb36680850768ff1b7f2a'),
	(20, '123qwe', 'default.png', '84984623', '46f94c8de14fb36680850768ff1b7f2a'),
	(21, 'Клиент', 'default.png', '2222222222', '46f94c8de14fb36680850768ff1b7f2a'),
	(22, 'Адель', 'default.png', '9655807629', '87102c03168c0ec622f7d8a77b8cda6d'),
	(23, 'Egorka', 'default.png', '2345555555', 'ba8bf13421895f97ada77e158d7d8951');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Дамп структуры для таблица newdiplom.users_accesses
CREATE TABLE IF NOT EXISTS `users_accesses` (
  `user_id` int(11) NOT NULL,
  `access_id` int(11) NOT NULL,
  KEY `access_id` (`access_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `users_accesses_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.users_accesses: ~11 rows (приблизительно)
/*!40000 ALTER TABLE `users_accesses` DISABLE KEYS */;
REPLACE INTO `users_accesses` (`user_id`, `access_id`) VALUES
	(7, 4),
	(6, 2),
	(11, 2),
	(12, 2),
	(13, 2),
	(14, 1),
	(16, 1),
	(20, 1),
	(21, 1),
	(22, 1),
	(23, 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы newdiplom.user_orders: ~15 rows (приблизительно)
/*!40000 ALTER TABLE `user_orders` DISABLE KEYS */;
REPLACE INTO `user_orders` (`id`, `order_id`, `user_id`) VALUES
	(80, 109, 11),
	(81, 110, 11),
	(82, 111, 11),
	(83, 112, 11),
	(84, 113, 11),
	(85, 114, 11),
	(86, 115, 7),
	(87, 116, 11),
	(88, 117, 11),
	(89, 119, 7),
	(90, 120, 7),
	(91, 121, 7),
	(92, 122, 11),
	(93, 123, 11),
	(94, 124, 11),
	(95, 125, 21),
	(96, 126, 11),
	(97, 127, 11),
	(98, 128, 21),
	(99, 129, 21),
	(100, 130, 21),
	(101, 131, 21),
	(102, 132, 21),
	(103, 133, 21),
	(104, 134, 21),
	(105, 135, 21),
	(106, 136, 21),
	(107, 137, 21),
	(108, 138, 21),
	(109, 139, 21),
	(110, 140, 21),
	(111, 141, 21),
	(112, 142, 21),
	(113, 143, 21),
	(114, 144, 21),
	(115, 145, 21),
	(116, 146, 11),
	(117, 147, 11),
	(118, 148, 11);
/*!40000 ALTER TABLE `user_orders` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
