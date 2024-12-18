# FILTER SQL database

This repository contains scripts for converting the FILTER corpus in
CSV format (provided in [filter-data](https://github.com/hsci-r/filter-data))
to a MariaDB database, which is needed by tools such as Runoregi and
Visualizations.

The computation is done in two stages. First, prepare the tables as text
files in the `data/` subdirectory by running:
```
DATA_DIR=/path/to/filter-data make all
```

Then, export the tables to the database. For exporting all tables,
you can run:
```
DB_NAME=... make dbexport
```
The MySQL access needs to be configured using environment variables:
* `DB_NAME` -- name of the database (must already exist)
* `MYSQL_GROUP_SUFFIX` -- the section in `my.cnf` containing database access data (preferred way of passing them)

Alternatively, you can run the export manually table by table by executing
the SQL files in the directory `tables/` using your SQL client.

Note that the frequency tables `v_clust_freq`, `p_clust_freq` and `word_freq`
need to be calculated at the end, i.e. after the respective source tables
`v_clust`, `p_clust`, `word_occ` and `verse_poem` have been exported.

