INSERT INTO dbmeta VALUES ('vp_al', current_timestamp(), 0)
  ON DUPLICATE KEY UPDATE last_modified = current_timestamp(), ready = 0;

DROP TABLE IF EXISTS `vp_al`;
CREATE TABLE `vp_al` (
  `p1_id` int(11) NOT NULL,
  `pos1` int(11) NOT NULL,
  `p2_id` int(11) NOT NULL,
  `pos2` int(11) NOT NULL,
  `sim` float DEFAULT NULL,
  PRIMARY KEY (`p1_id`,`pos1`,`p2_id`,`pos2`),
  KEY `sim` (`sim`),
  KEY `p2_id` (`p2_id`,`pos2`)
) ENGINE=Aria DEFAULT CHARSET=utf8mb4 PAGE_CHECKSUM=0 TRANSACTIONAL=0;

ALTER TABLE vp_al DISABLE KEYS;
LOAD DATA LOCAL INFILE 'data/vp_al.tbl.csv' INTO TABLE vp_al
  FIELDS TERMINATED BY ',' IGNORE 1 ROWS;
ALTER TABLE vp_al ENABLE KEYS;

UPDATE dbmeta SET last_modified = current_timestamp(), ready = 1
  WHERE table_name = 'vp_al';
