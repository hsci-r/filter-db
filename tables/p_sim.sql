INSERT INTO dbmeta VALUES ('p_sim', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS p_sim;
CREATE TABLE p_sim(
  p1_id INTEGER,
  p2_id INTEGER,
  sim_raw FLOAT DEFAULT NULL,
  sim_al_l FLOAT DEFAULT NULL,
  sim_al_r FLOAT DEFAULT NULL,
  sim_al FLOAT DEFAULT NULL,
  PRIMARY KEY(p1_id, p2_id),
  KEY(p2_id),
  KEY(sim_al)
) ENGINE=Aria DEFAULT CHARSET=utf8mb4 PAGE_CHECKSUM=0 TRANSACTIONAL=0;

ALTER TABLE p_sim DISABLE KEYS;
LOAD DATA LOCAL INFILE 'data/p_sim.tbl.csv' INTO TABLE p_sim
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;
ALTER TABLE p_sim ENABLE KEYS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'p_sim';
