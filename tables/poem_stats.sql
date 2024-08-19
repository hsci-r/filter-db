INSERT INTO dbmeta VALUES ('poem_stats', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS poem_stats;
CREATE TABLE poem_stats(
  p_id INTEGER NOT NULL,
  nverses INTEGER UNSIGNED,
  n_all_lines INTEGER UNSIGNED,
  PRIMARY KEY(p_id)
);

INSERT INTO poem_stats
SELECT vp.p_id, SUM(IF(v.type = "V", 1, 0)), COUNT(*)
FROM
  verse_poem vp
  join verses v on vp.v_id = v.v_id
GROUP BY vp.p_id;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'poem_stats';
