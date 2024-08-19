INSERT INTO dbmeta VALUES ('verse_poem', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS `verse_poem`;
CREATE TABLE `verse_poem`(
  p_id INTEGER NOT NULL,
  pos INTEGER NOT NULL,
  v_id INTEGER NOT NULL,
  PRIMARY KEY(p_id, pos),
  INDEX(p_id),
  INDEX(v_id)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/verse_poem.tbl.csv' INTO TABLE verse_poem
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'verse_poem';
