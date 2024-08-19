INSERT INTO dbmeta VALUES ('p_clust', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS p_clust;
CREATE TABLE p_clust(
  p_id INTEGER,
  clust_id INTEGER,
  PRIMARY KEY(p_id),
  INDEX(clust_id)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/p_clust.tbl.csv' INTO TABLE p_clust
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'p_clust';
