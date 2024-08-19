DROP TABLE IF EXISTS `dbmeta`;
CREATE TABLE `dbmeta`(
  table_name CHAR(50) NOT NULL,
  last_modified DATETIME DEFAULT current_timestamp(),
  ready TINYINT(1) DEFAULT 0,
  PRIMARY KEY `table_name` (`table_name`)
);

INSERT INTO `dbmeta` VALUES ('dbmeta', current_timestamp(), 1);

