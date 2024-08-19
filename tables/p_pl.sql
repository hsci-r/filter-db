INSERT INTO dbmeta VALUES ('p_pl', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS `p_pl`;
CREATE TABLE p_pl(
  p_id INTEGER NOT NULL,
  pl_id INTEGER NOT NULL,
  PRIMARY KEY(p_id, pl_id),
  INDEX(pl_id)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/p_pl.tbl.csv' INTO TABLE p_pl
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'p_pl';
