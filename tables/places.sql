INSERT INTO dbmeta VALUES ('places', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS `places`;
CREATE TABLE places(
  pl_id INTEGER NOT NULL,
  place_orig_id CHAR(10) DEFAULT NULL,
  name VARCHAR(50) DEFAULT NULL,
  type ENUM('parish', 'county') DEFAULT NULL,
  par_id INTEGER DEFAULT NULL,
  PRIMARY KEY(pl_id),
  FULLTEXT KEY (name)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/places.tbl.csv' INTO TABLE places
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'places';
