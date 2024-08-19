INSERT INTO dbmeta VALUES ('word_freq', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS word_freq;
CREATE TABLE word_freq(
  w_id INTEGER,
  freq INTEGER,
  PRIMARY KEY(w_id)
) CHARACTER SET 'utf8';

INSERT INTO word_freq
SELECT w_id, COUNT(*) AS freq
FROM
  verse_poem vp
  JOIN word_occ wo ON vp.v_id = wo.v_id
GROUP BY w_id;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'word_freq';
