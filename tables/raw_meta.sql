INSERT INTO dbmeta VALUES ('raw_meta', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS raw_meta;
CREATE TABLE raw_meta(
  p_id INTEGER,
  field VARCHAR(10),
  value VARCHAR(10000),
  PRIMARY KEY(p_id, field),
  FULLTEXT KEY `value` (`value`)
) CHARACTER SET 'utf8' COLLATE 'utf8_estonian_ci';

LOAD DATA LOCAL INFILE 'data/raw_meta.tbl.csv' INTO TABLE raw_meta
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'raw_meta';
