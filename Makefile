DATA_DIR := $(if $(DATA_DIR),$(DATA_DIR),input)
tmp_dir = data

python = python3
trk = $(python) scripts/translate_keys.py
mysql = mysql -D $(DB_NAME)

###################################################################
# RUNOREGI DATABASE
# (generating unique numeric keys for the combined dataset)
###################################################################

all: \
  $(tmp_dir) \
  $(tmp_dir)/poems.tbl.csv \
  $(tmp_dir)/collectors.tbl.csv \
  $(tmp_dir)/maps.tbl.csv \
  $(tmp_dir)/map_pol.tbl.csv \
  $(tmp_dir)/places.tbl.csv \
  $(tmp_dir)/pol_pl.tbl.csv \
  $(tmp_dir)/p_col.tbl.csv \
  $(tmp_dir)/p_dupl.tbl.csv \
  $(tmp_dir)/p_pl.tbl.csv \
  $(tmp_dir)/p_year.tbl.csv \
  $(tmp_dir)/p_typ.tbl.csv \
  $(tmp_dir)/p_sim.tbl.csv \
  $(tmp_dir)/p_clust.tbl.csv \
  $(tmp_dir)/polygons.tbl.csv \
  $(tmp_dir)/raw_meta.tbl.csv \
  $(tmp_dir)/refs.tbl.csv \
  $(tmp_dir)/runoregi_pages.tbl.tsv \
  $(tmp_dir)/verse_poem.tbl.csv \
  $(tmp_dir)/verses.tbl.csv \
  $(tmp_dir)/verses_cl.tbl.csv \
  $(tmp_dir)/v_sim.tbl.csv \
  $(tmp_dir)/v_clust.tbl.csv \
  $(tmp_dir)/word_occ.tbl.csv \
  $(tmp_dir)/words.tbl.csv

$(tmp_dir):
	mkdir -p $(tmp_dir)

$(tmp_dir)/collectors.tbl.csv: $(DATA_DIR)/collectors.csv
	$(trk) -i $< \
	       -o /dev/null \
	       -d collector_id,collector_name:col_id:$@

$(tmp_dir)/maps.tbl.csv:
	echo 'map_id,name' > $@
	echo '0,"parishes (all)",' >> $@
	echo '1,"counties (all)"' >> $@
	echo '2,"parishes (Northern)"' >> $@
	echo '3,"counties (Northern)"' >> $@
	echo '4,"parishes (Southern)"' >> $@
	echo '5,"counties (Southern)"' >> $@

$(tmp_dir)/map_pol.tbl.csv: \
  $(DATA_DIR)/areas.geojson \
  $(DATA_DIR)/counties.geojson
	echo 'map_id,pol_id' > $@
	jq -r '.features[] | [.properties.id ] | @csv' \
	  $(DATA_DIR)/areas.geojson \
	| sed 's/^/0,/' >> $@
	jq -r '.features[] | [.properties.id ] | @csv' \
	  $(DATA_DIR)/counties.geojson \
	| sed 's/^/1,/' >> $@
	jq -r '.features[] | select(.properties.parish_name == "Setumaa") '\
	'      | [.properties.id] | @tsv' $(DATA_DIR)/areas.geojson \
	| sed 's/^/1,/' >> $@
	jq -r '.features[] | select(.properties.parish_language != null) '\
	'      | select(.properties.parish_language | test("kaA|su|ru|kaV|ka|in|ve|suI|ly"; ""))'\
	'      | [ .properties.id ] | @csv' $(DATA_DIR)/areas.geojson \
	| sed 's/^/2,/' >> $@
	jq -r '.features[] | select(.properties.county_language != null) '\
	'      | select(.properties.county_language | test("kaA|su|ru|kaV|ka|in|ve|suI|ly"; ""))'\
	'      | [ .properties.id ] | @csv' $(DATA_DIR)/counties.geojson \
	| sed 's/^/3,/' >> $@
	jq -r '.features[] | select(.properties.parish_language != null) '\
	'      | select(.properties.parish_language | test("viP|viE"; ""))'\
	'      | [ .properties.id ] | @csv' $(DATA_DIR)/areas.geojson \
	| sed 's/^/4,/' >> $@
	jq -r '.features[] | select(.properties.county_language != null) '\
	'      | select(.properties.county_language | test("viP|viE"; ""))'\
	'      | [ .properties.id ] | @csv' $(DATA_DIR)/counties.geojson \
	| sed 's/^/5,/' >> $@
	jq -r '.features[] | select(.properties.parish_name == "Setumaa") '\
	'      | [.properties.id] | @tsv' $(DATA_DIR)/areas.geojson \
	| sed 's/^/5,/' >> $@

$(tmp_dir)/places.tbl.csv: $(DATA_DIR)/places.csv
	$(trk) -i $< -o $(tmp_dir)/places.tmp1.csv \
	       -d place_id:pl_id:$(tmp_dir)/places.idmap.csv
	$(trk) -i $(tmp_dir)/places.tmp1.csv \
	       -o $(tmp_dir)/places.tmp2.csv \
	       -d place_parent_id:par_id:$(tmp_dir)/places.idmap.csv:par_id,place_parent_id
	sed -i '1s/par_id,place_parent_id/pl_id,place_id/' $(tmp_dir)/places.idmap.csv
	ROOT_PLACE_ID=$$(tail -n 1 $(tmp_dir)/places.idmap.csv | cut -d, -f 1) \
	&& sed -i "s/,$$ROOT_PLACE_ID\$$/,/" $(tmp_dir)/places.tmp2.csv
	csvjoin -c pl_id $(tmp_dir)/places.idmap.csv \
                     $(tmp_dir)/places.tmp2.csv > $@
	rm -f $(tmp_dir)/places.tmp*

$(tmp_dir)/polygons.tbl.csv: \
  $(DATA_DIR)/areas.geojson \
  $(DATA_DIR)/counties.geojson
	jq -r '.features[] | [.properties.id, .properties.parish_scripts,'\
	'                     .properties.parish_language, .properties.parish_name,'\
	'                     .geometry | tostring] | @tsv' \
	  $(DATA_DIR)/areas.geojson > $@
	jq -r '.features[] | [.properties.id, null,'\
	'                     .properties.county_language, .properties.county_name,'\
	'                     .geometry | tostring] | @tsv' \
	  $(DATA_DIR)/counties.geojson >> $@

$(tmp_dir)/pol_pl.tbl.csv: \
  $(DATA_DIR)/polygon_to_place.csv \
  $(DATA_DIR)/counties.geojson \
  $(tmp_dir)/places.tbl.csv
	$(trk) -i $(DATA_DIR)/polygon_to_place.csv -O \
	  -d place_id:pl_id:$(tmp_dir)/places.idmap.csv > $@

$(tmp_dir)/types.tbl.csv: $(DATA_DIR)/types.csv
	mkdir -p $(tmp_dir)
	$(trk) -i $< -o $(tmp_dir)/types.tmp1.csv \
	       -d type_id:t_id:$(tmp_dir)/types.idmap.csv
	$(trk) -i $(tmp_dir)/types.tmp1.csv \
	       -o $(tmp_dir)/types.tmp2.csv \
	       -d type_parent_id:par_id:$(tmp_dir)/types.idmap.csv:par_id,type_parent_id
	sed -i '1s/par_id,type_parent_id/t_id,type_id/' $(tmp_dir)/types.idmap.csv
	ROOT_TYPE_ID=$$(tail -n 1 $(tmp_dir)/types.idmap.csv | cut -d, -f 1) \
	&& sed -i "s/,$$ROOT_TYPE_ID\$$/,/" $(tmp_dir)/types.tmp2.csv
	csvjoin -c t_id $(tmp_dir)/types.idmap.csv \
                    $(tmp_dir)/types.tmp2.csv > $@
	rm -f $(tmp_dir)/types.tmp*

$(tmp_dir)/verses.tbl.csv: $(tmp_dir)/verse_poem.tbl.csv

$(tmp_dir)/poems.tbl.csv: $(DATA_DIR)/poems.csv
	mkdir -p $(tmp_dir)
	$(trk) -a -i $< -o $@ -d poem_id:p_id:$(tmp_dir)/poems.idmap.csv

$(tmp_dir)/verse_poem.tbl.csv: $(DATA_DIR)/verses.csv
	mkdir -p $(tmp_dir)
	$(trk) -i $< -o $@ \
	       -d verse_type,text:v_id:$(tmp_dir)/verses.tbl.csv \
	          poem_id:p_id:$(tmp_dir)/poems.idmap.csv

$(tmp_dir)/verses_cl.tbl.csv: \
  $(DATA_DIR)/verses_cl.csv \
  $(tmp_dir)/verse_poem.tbl.csv
	$(trk) -i $< -d poem_id:p_id:$(tmp_dir)/poems.idmap.csv \
	| $(python) scripts/map_columns.py -u -f p_id,pos -t v_id \
        $(tmp_dir)/verse_poem.tbl.csv > $@

$(tmp_dir)/word_occ.tbl.csv: \
  $(DATA_DIR)/word_occ.csv \
  $(tmp_dir)/verse_poem.tbl.csv
	$(trk) -i $< -d poem_id:p_id:$(tmp_dir)/poems.idmap.csv \
	                text:w_id:$(tmp_dir)/words.tbl.csv \
	| $(python) scripts/map_columns.py -u -f p_id,pos -t v_id \
	    $(tmp_dir)/verse_poem.tbl.csv > $@

$(tmp_dir)/words.tbl.csv: $(tmp_dir)/word_occ.tbl.csv

# Files do not exist -- dummy targets for computing the tables in SQL.
$(tmp_dir)/p_clust_freq.tbl.csv:
$(tmp_dir)/v_clust_freq.tbl.csv:
$(tmp_dir)/word_freq.tbl.csv:
$(tmp_dir)/place_stats.tbl.csv:

$(tmp_dir)/raw_meta.tbl.csv: \
  $(DATA_DIR)/raw_meta.csv \
  $(tmp_dir)/poems.tbl.csv
	$(trk) -i $< -o $@ -d poem_id:p_id:$(tmp_dir)/poems.idmap.csv

$(tmp_dir)/p_col.tbl.csv: \
  $(DATA_DIR)/poem_collector.csv \
  $(tmp_dir)/collectors.tbl.csv
	csvcut -c col_id,collector_id $(tmp_dir)/collectors.tbl.csv \
	  > $(tmp_dir)/collectors.idmap.csv
	$(trk) -O -i $< -o $@ \
	       -d poem_id:p_id:$(tmp_dir)/poems.idmap.csv \
	          collector_id:col_id:$(tmp_dir)/collectors.idmap.csv

$(tmp_dir)/runoregi_pages.tbl.tsv: \
  $(DATA_DIR)/runoregi_pages.tsv
	cp $< $@

$(tmp_dir)/p_dupl.tbl.csv: $(DATA_DIR)/poem_duplicates.csv
	$(trk) -O -i $(DATA_DIR)/poem_duplicates.csv -o $@ \
	       -d poem_id:p_id:$(tmp_dir)/poems.idmap.csv \
	          master_poem_id:master_p_id:$(tmp_dir)/poems.idmap.csv:master_p_id,master_poem_id

$(tmp_dir)/p_pl.tbl.csv: \
  $(DATA_DIR)/poem_place.csv \
  $(tmp_dir)/places.tbl.csv
	$(trk) -O -i $< -o $@ \
	       -d poem_id:p_id:$(tmp_dir)/poems.idmap.csv \
	          place_id:pl_id:$(tmp_dir)/places.idmap.csv

$(tmp_dir)/p_year.tbl.csv: \
  $(DATA_DIR)/poem_year.csv
	$(trk) -O -i $< -o $@ -d poem_id:p_id:$(tmp_dir)/poems.idmap.csv

$(tmp_dir)/p_typ.tbl.csv: \
  $(DATA_DIR)/poem_types.csv \
  $(tmp_dir)/types.tbl.csv
	$(trk) -O -i $< -o $@ \
	       -d poem_id:p_id:$(tmp_dir)/poems.idmap.csv \
	          type_id:t_id:$(tmp_dir)/types.idmap.csv

$(tmp_dir)/refs.tbl.csv: \
  $(DATA_DIR)/refs.csv
	$(trk) -i $< -o $@ -d poem_id:p_id:$(tmp_dir)/poems.idmap.csv

$(tmp_dir)/p_sim.tbl.csv: $(DATA_DIR)/p_sim.csv
	$(trk) -O -i $< -o $@ \
	  -d poem_id_1:p1_id:$(tmp_dir)/poems.idmap.csv:p1_id,poem_id_1 \
	     poem_id_2:p2_id:$(tmp_dir)/poems.idmap.csv:p2_id,poem_id_2

$(tmp_dir)/p_clust.tbl.csv: $(DATA_DIR)/p_clust.tsv
	csvformat -t $< | sed '1ipoem_id,clust_id' \
	| $(trk) -i - -o $@ -d poem_id:p_id:data/poems.idmap.csv

$(tmp_dir)/v_clusterings.tbl.csv: $(DATA_DIR)/v_clusterings.csv
	cp $< $@

$(tmp_dir)/v_sim.tbl.csv: $(DATA_DIR)/v_sim.tsv
	csvformat -t $< | sed '1itext_1,text_2,sim' \
	| python3 scripts/map_columns.py -m -f text_1 -t v1_id -H v1_id,text_1 \
	                                 $(tmp_dir)/verses_cl.tbl.csv \
	| python3 scripts/map_columns.py -m -f text_2 -t v2_id -H v2_id,text_2 \
	                                 $(tmp_dir)/verses_cl.tbl.csv > $@

$(tmp_dir)/v_clust.tbl.csv: $(DATA_DIR)/v_clust.tsv
	csvformat -t $< | sed '1iclustering_id,text,clust_id' \
	| python3 scripts/map_columns.py -m -f text -t v_id \
	                                 $(tmp_dir)/verses_cl.tbl.csv > $@

###################################################################
# DATABASE EXPORT
###################################################################

dbexport: \
  collectors.tbl \
  places.tbl \
  p_col.tbl \
  p_pl.tbl \
  p_year.tbl \
  p_typ.tbl \
  pol_pl.tbl \
  polygons.tbl \
  raw_meta.tbl \
  poems.tbl \
  refs.tbl \
  types.tbl \
  verse_poem.tbl \
  verses.tbl \
  verses_cl.tbl \
  words.tbl \
  word_occ.tbl \
  p_clust_freq.tbl \
  v_clust_freq.tbl \
  word_freq.tbl \
  place_stats.tbl

%.tbl: $(tmp_dir)/%.tbl.csv
	$(mysql) < tables/$*.sql

