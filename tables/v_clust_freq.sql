INSERT INTO dbmeta VALUES ('v_clust_freq', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS v_clust_freq;
CREATE TABLE v_clust_freq(
  clust_id INTEGER,
  freq INTEGER,
  clustering_id TINYINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY(clustering_id, clust_id)
) CHARACTER SET 'utf8';

INSERT INTO v_clust_freq
SELECT clust_id, COUNT(*) AS freq, clustering_id
FROM
  verse_poem vp
  JOIN v_clust vc ON vp.v_id = vc.v_id
GROUP BY clustering_id, clust_id;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'v_clust_freq';
