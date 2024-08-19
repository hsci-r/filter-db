INSERT INTO dbmeta VALUES ('p_clust_freq', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS p_clust_freq;
CREATE TABLE p_clust_freq(
  clust_id INTEGER,
  freq INTEGER,
  PRIMARY KEY(clust_id)
) CHARACTER SET 'utf8';

INSERT INTO p_clust_freq
SELECT clust_id, COUNT(*) AS freq
FROM
  p_clust
GROUP BY clust_id;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'p_clust_freq';
