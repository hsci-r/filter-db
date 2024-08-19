INSERT INTO dbmeta VALUES ('verses', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS verses;
CREATE TABLE verses(
  v_id INTEGER NOT NULL,
  type CHAR(3),
  text VARCHAR(10000),
  PRIMARY KEY(v_id),
  FULLTEXT KEY `text` (`text`)
) CHARACTER SET 'utf8' COLLATE 'utf8_estonian_ci';

LOAD DATA LOCAL INFILE 'data/verses.tbl.csv' INTO TABLE verses
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'verses';
