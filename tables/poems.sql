INSERT INTO dbmeta VALUES ('poems', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS poems;
CREATE TABLE poems(
  p_id INTEGER NOT NULL,
  nro CHAR(16),
  collection ENUM('skvr', 'erab', 'jr', 'literary') DEFAULT NULL,
  title VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY(p_id),
  KEY(nro),
  KEY(collection),
  KEY(title)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/poems.tbl.csv' INTO TABLE poems
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 ROWS
  (p_id, nro)
  SET collection = CASE REGEXP_REPLACE(nro, '[0-9]+.*', '')
      WHEN 'skvr' THEN 'skvr'
      WHEN 'j' THEN 'jr'
      WHEN 'ilj' THEN 'literary'
      WHEN 'kt' THEN 'literary'
      WHEN 'kalevala' THEN 'literary'
      WHEN 'kalevipoeg' THEN 'literary'
      WHEN 'vkalevala' THEN 'literary'
      WHEN 'kr' THEN 'literary'
      ELSE 'erab'
    END
;

-- Generate the titles
UPDATE poems p
  LEFT JOIN raw_meta rm_osa ON rm_osa.p_id = p.p_id AND rm_osa.field = 'OSA'
  LEFT JOIN raw_meta rm_id ON rm_id.p_id = p.p_id AND rm_id.field = 'ID'
SET
  p.title = CASE p.collection
     WHEN 'skvr' THEN CONCAT('SKVR ', rm_osa.value, ' ', rm_id.value)
     WHEN 'erab' THEN rm_id.value
     WHEN 'jr' THEN CONCAT('JR ', rm_id.value)
     WHEN 'literary' THEN CASE
         WHEN p.nro REGEXP 'kt.*' THEN CONCAT(
             'Kanteletar ',
             IF(SUBSTRING(p.nro, 3, 2) = '00', '0',
                REGEXP_REPLACE(SUBSTRING(p.nro, 3, 2), '^0*', '')),
             ':',
             REGEXP_REPLACE(SUBSTRING(p.nro, 5), '^0*', '')
         )
         WHEN p.nro REGEXP 'kr.*' THEN CONCAT(
             'KR ',
             REGEXP_REPLACE(SUBSTRING(p.nro, 3, 5), '^0*', ''),
             ':',
             REGEXP_REPLACE(SUBSTRING(p.nro, 8), '^0*', '')
         )
         ELSE CONCAT(rm_osa.value, ' ', rm_id.value)
       END
   END
;
UPDATE poems SET title = nro WHERE title IS NULL;


UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'poems';
