INSERT INTO dbmeta VALUES ('p_dupl', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS `p_dupl`;
CREATE TABLE p_dupl(
  p_id INTEGER NOT NULL,
  master_p_id INTEGER NOT NULL,
  PRIMARY KEY(p_id, master_p_id),
  KEY(p_id),
  KEY(master_p_id)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/p_dupl.tbl.csv' INTO TABLE p_dupl
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'p_dupl';
