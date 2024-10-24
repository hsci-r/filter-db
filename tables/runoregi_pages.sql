DROP TABLE IF EXISTS runoregi_pages;

CREATE TABLE runoregi_pages(
  b_id INTEGER NOT NULL auto_increment,
  view CHAR(16),
  position ENUM ("left", "main", "right"),
  title VARCHAR(255),
  helptext VARCHAR(2000),
  content TEXT,
  PRIMARY KEY(b_id),
  KEY(view)
) CHARACTER SET 'utf8';

LOAD DATA LOCAL INFILE 'data/runoregi_pages.tbl.tsv'
  INTO TABLE runoregi_pages (view, position, title, helptext, content);

