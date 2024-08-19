INSERT INTO dbmeta VALUES ('v_clusterings', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS v_clusterings;
CREATE TABLE v_clusterings(
  `clustering_id` TINYINT NOT NULL,
  `name` VARCHAR(20),
  `description` VARCHAR(500),
  PRIMARY KEY (`clustering_id`)
);

LOAD DATA LOCAL INFILE 'data/v_clusterings.tbl.csv' INTO TABLE v_clusterings
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'v_clusterings';
