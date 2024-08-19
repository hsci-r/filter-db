INSERT INTO dbmeta VALUES ('maps', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS maps;
CREATE TABLE maps(
  `map_id` TINYINT NOT NULL,
  `name` VARCHAR(20),
  PRIMARY KEY (`map_id`)
);

LOAD DATA LOCAL INFILE 'data/maps.tbl.csv' INTO TABLE maps
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'maps';
