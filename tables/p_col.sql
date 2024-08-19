INSERT INTO dbmeta VALUES ('p_col', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS `p_col`;
CREATE TABLE p_col(
  p_id INTEGER NOT NULL,
  col_id INTEGER NOT NULL,
  PRIMARY KEY(p_id, col_id),
  INDEX(p_id)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/p_col.tbl.csv' INTO TABLE p_col
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'p_col';
