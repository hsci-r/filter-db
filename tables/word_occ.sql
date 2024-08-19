INSERT INTO dbmeta VALUES ('word_occ', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS word_occ;
CREATE TABLE word_occ(
  v_id INTEGER NOT NULL,
  pos INTEGER NOT NULL,
  w_id INTEGER NOT NULL,
  PRIMARY KEY(v_id, pos),
  INDEX(w_id)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/word_occ.tbl.csv' INTO TABLE word_occ
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'word_occ';
