INSERT INTO dbmeta VALUES ('map_pol', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS map_pol;
CREATE TABLE map_pol(
  `map_id` TINYINT NOT NULL,
  `pol_id` INTEGER NOT NULL, 
  PRIMARY KEY (`map_id`, `pol_id`)
);

LOAD DATA LOCAL INFILE 'data/map_pol.tbl.csv' INTO TABLE map_pol
  FIELDS TERMINATED BY ',';

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'map_pol';
