CREATE TABLE `autocomplete` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `title` varchar(255) DEFAULT NULL,
      PRIMARY KEY (`id`),
      FULLTEXT KEY `title_index` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=51646 DEFAULT CHARSET=utf8;
