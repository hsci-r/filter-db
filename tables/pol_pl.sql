INSERT INTO dbmeta VALUES ('pol_pl', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS `pol_pl`;
CREATE TABLE `pol_pl`(
  pol_id INTEGER NOT NULL,
  pl_id INTEGER NOT NULL,
  is_primary TINYINT NOT NULL,
  PRIMARY KEY (pol_id, pl_id),
  INDEX (pl_id)
);

LOAD DATA LOCAL INFILE 'data/pol_pl.tbl.csv' INTO TABLE pol_pl
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'pol_pl';
