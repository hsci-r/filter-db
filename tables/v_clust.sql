INSERT INTO dbmeta VALUES ('v_clust', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS v_clust;
CREATE TABLE v_clust(
  clustering_id TINYINT UNSIGNED NOT NULL DEFAULT 0,
  v_id INTEGER,
  clust_id INTEGER,
  score FLOAT DEFAULT NULL,
  confidence FLOAT DEFAULT NULL,
  PRIMARY KEY(clustering_id, v_id),
  INDEX(clustering_id, clust_id)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/v_clust.tbl.csv' INTO TABLE v_clust
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'v_clust';
