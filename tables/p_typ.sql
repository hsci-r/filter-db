INSERT INTO dbmeta VALUES ('p_typ', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS p_typ;
CREATE TABLE p_typ(
  p_id INTEGER NOT NULL,
  t_id INTEGER NOT NULL,
  is_minor TINYINT(1) DEFAULT 0,
  PRIMARY KEY(p_id, t_id),
  INDEX(p_id),
  INDEX(t_id)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/p_typ.tbl.csv' INTO TABLE p_typ
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'p_typ';
