INSERT INTO dbmeta VALUES ('word_cooc', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS `word_cooc`;
CREATE TABLE `word_cooc`(
  `w1_id` INTEGER NOT NULL,
  `w2_id` INTEGER NOT NULL,
  `freq` INTEGER UNSIGNED DEFAULT NULL,
  `logl` FLOAT DEFAULT NULL,
  `dice` FLOAT DEFAULT NULL,
  `mutinf` FLOAT DEFAULT NULL,
  PRIMARY KEY (`w1_id`, `w2_id`),
  KEY (`w1_id`)
) ENGINE=Aria PAGE_CHECKSUM=0 TRANSACTIONAL=0;

LOAD DATA LOCAL INFILE 'data/word_cooc.tbl.csv' INTO TABLE word_cooc
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'word_cooc';
