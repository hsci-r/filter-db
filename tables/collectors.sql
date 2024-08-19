INSERT INTO dbmeta VALUES ('collectors', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS `collectors`;
CREATE TABLE collectors(
  col_id INTEGER NOT NULL,
  col_orig_id CHAR(10) DEFAULT NULL,
  name VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY(col_id),
  FULLTEXT KEY(name)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/collectors.tbl.csv' INTO TABLE collectors
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'collectors';
