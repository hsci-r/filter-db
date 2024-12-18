INSERT INTO dbmeta VALUES ('poems', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS poems_test;
CREATE TABLE poems_test(
  p_id INTEGER NOT NULL,
  nro CHAR(16),
  collection CHAR(8) DEFAULT NULL,
  display_name VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY(p_id),
  KEY(nro),
  KEY(collection),
  KEY(display_name)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/poems.tbl.csv' INTO TABLE poems_test
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS;

UPDATE poems_test SET display_name = nro WHERE display_name IS NULL;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'poems';
