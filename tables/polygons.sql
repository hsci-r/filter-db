INSERT INTO dbmeta VALUES ('polygons', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS polygons;
CREATE TABLE polygons(
  pol_id INTEGER NOT NULL, 
  lang ENUM('in', 'ka', 'kaA', 'kaV', 'li', 'ly', 'ru', 'su', 'suI',
            'va', 've', 'viE', 'viP', 'x'),
  code VARCHAR(10),
  name VARCHAR(50),
  geometry BLOB,
  PRIMARY KEY(pol_id)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/polygons.tbl.csv' INTO TABLE polygons
  (pol_id, code, @lang, name, @geojson)
SET
  geometry = ST_GeomFromGeoJSON(@geojson),
  lang = IF(@lang = 'null', NULL, @lang);

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'polygons';
