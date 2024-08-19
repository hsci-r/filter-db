INSERT INTO dbmeta VALUES ('words', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS `words`;
CREATE TABLE `words`(
  `w_id` INTEGER NOT NULL,
  `text` VARCHAR(1000) CHARACTER SET utf8 COLLATE utf8_bin,
  PRIMARY KEY(`w_id`),
  INDEX (`text`)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/words.tbl.csv' INTO TABLE words
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'words';
