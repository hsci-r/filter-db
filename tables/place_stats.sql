INSERT INTO dbmeta VALUES ('place_stats', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS place_stats;

CREATE TABLE place_stats(
  pl_id INTEGER NOT NULL,
  collection ENUM('skvr', 'erab', 'jr', 'literary'),
  npoems INTEGER UNSIGNED DEFAULT 0,
  nverses INTEGER UNSIGNED DEFAULT 0,
  nwords INTEGER UNSIGNED DEFAULT 0,
  PRIMARY KEY(pl_id, collection)
);

INSERT INTO place_stats
SELECT
  pl.pl_id AS pl_id,
  IFNULL(p.collection, 'literary') AS collection,
  COUNT(DISTINCT vp.p_id) AS npoems,
  COUNT(DISTINCT vp.p_id, vp.pos) AS nverses,
  SUM(IF(w_id IS NOT NULL, 1, 0)) AS nwords
FROM
  places pl
  LEFT JOIN p_pl ON pl.pl_id = p_pl.pl_id
  LEFT JOIN poems p ON p_pl.p_id = p.p_id
  LEFT JOIN verse_poem vp ON p_pl.p_id = vp.p_id
  LEFT JOIN word_occ wo ON vp.v_id = wo.v_id
GROUP BY pl.pl_id, p.collection
;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'place_stats';
