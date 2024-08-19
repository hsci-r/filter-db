INSERT INTO dbmeta VALUES ('p_year', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS `p_year`;
CREATE TABLE p_year(
  p_id INTEGER NOT NULL,
  year INTEGER,
  PRIMARY KEY(p_id)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/p_year.tbl.csv' INTO TABLE p_year
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'p_year';
