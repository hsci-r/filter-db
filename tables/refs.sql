INSERT INTO dbmeta VALUES ('refs', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS refs;
CREATE TABLE refs(
  p_id INTEGER NOT NULL,
  num INTEGER(4) DEFAULT NULL,
  type CHAR(4),
  text VARCHAR(10000),
  PRIMARY KEY(p_id, num)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/refs.tbl.csv' INTO TABLE refs
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'refs';
