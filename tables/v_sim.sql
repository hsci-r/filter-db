INSERT INTO dbmeta VALUES ('v_sim', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS v_sim;
CREATE TABLE v_sim(
  v1_id INTEGER NOT NULL,
  v2_id INTEGER NOT NULL,
  sim_cos FLOAT DEFAULT NULL,
  PRIMARY KEY(v1_id, v2_id),
  INDEX(v1_id)
) ENGINE=Aria PAGE_CHECKSUM=0 TRANSACTIONAL=0;

ALTER TABLE v_sim DISABLE KEYS;
LOAD DATA LOCAL INFILE 'data/v_sim.tbl.csv' INTO TABLE v_sim
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;
ALTER TABLE v_sim ENABLE KEYS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'v_sim';
