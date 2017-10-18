#!/bin/bash
# Depends on https://github.com/ashima/pdf-table-extract and curl

. ./html.sh

# Create new temp folder
mkdir -p /tmp/vertretungsplan;
export TMPPATH="/tmp/vertretungsplan"

# Download pdf with authentification
curl https://gho.berlin/wp-content/frei_stunden/VPS.pdf --user "<username>:<password>" --output $TMPPATH/vertretungsplan.pdf
curl https://gho.berlin/download/115/allgemeine-informationen/5731/arbeitsgemeinschaften_2017_2018.pdf --output $TMPPATH/ags.pdf

# extract table from pdf
pdf-table-extract -i $TMPPATH/vertretungsplan.pdf -t table_html -p 2 -o $TMPPATH/vertretungsplan-table.html
pdf-table-extract -i $TMPPATH/vertretungsplan.pdf -t cells_xml -p 2 -o vertretungsplan-cells.xml
pdf-table-extract -i $TMPPATH/vertretungsplan.pdf -t cells_json -p 2 -o vertretungsplan-cells.json

pdf-table-extract -i $TMPPATH/ags.pdf -t table_html -p 1 -o $TMPPATH/ags-table.html
pdf-table-extract -i $TMPPATH/ags.pdf -t cells_xml -p 1 -o ags-cells.xml
pdf-table-extract -i $TMPPATH/ags.pdf -t cells_json -p 1 -o ags-cells.json

for i in $TMPPATH/*vertretungsplan*; do
	# Replace some strings to be easier to understand
	sed -i s/"VLehrer Kürzel"/"Vertretungslehrer (Kürzel)"/g $i
	sed -i s/"Pos"/"Stunde"/g $i

	# Correct spelling misstakes
	sed -i s/"Fällt"/"fällt"/g $i
done

# Vertretungsplan
export HTML=$(cat $TMPPATH/vertretungsplan-table.html)
export GENTIME=$(TZ='Europe/Berlin' date)
export TITLE=Vertretungsplan
export TARGET=vertretungsplan.html
export SOURCE=https://gho.berlin/wp-content/frei_stunden/VPS.pdf
gen_from_html_template

# AGs
export HTML=$(cat $TMPPATH/ags-table.html)
export GENTIME=$(TZ='Europe/Berlin' date)
export TITLE=AGs
export TARGET=ags.html
export SOURCE=https://gho.berlin/download/115/allgemeine-informationen/5731/arbeitsgemeinschaften_2017_2018.pdf
gen_from_html_template

rm $TMPPATH/ -r
