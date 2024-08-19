INSERT INTO dbmeta VALUES ('types', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS types;
CREATE TABLE types(
  t_id INTEGER NOT NULL,
  type_orig_id VARCHAR(20),
  name VARCHAR(100),
  description VARCHAR(10000),
  par_id INTEGER DEFAULT NULL,
  PRIMARY KEY(t_id),
  KEY(type_orig_id),
  FULLTEXT KEY `name` (`name`),
  FULLTEXT KEY `description` (`description`)
) CHARACTER SET 'utf8' COLLATE 'utf8_estonian_ci';

LOAD DATA LOCAL INFILE 'data/types.tbl.csv' INTO TABLE types
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'types';
