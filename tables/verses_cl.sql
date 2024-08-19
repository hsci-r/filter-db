INSERT INTO dbmeta VALUES ('verses_cl', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS verses_cl;
CREATE TABLE verses_cl(
  v_id INTEGER NOT NULL,
  text VARCHAR(200),
  PRIMARY KEY(v_id)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/verses_cl.tbl.csv' INTO TABLE verses_cl
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'verses_cl';
