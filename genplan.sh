#!/bin/bash
# Depends on https://github.com/ashima/pdf-table-extract and curl

# Create new temp folder
mkdir -p /tmp/vertretungsplan;
export TMPPATH="/tmp/vertretungsplan"

# Download pdf with authentification
curl https://gho.berlin/wp-content/frei_stunden/VPS.pdf --user "<username>:<password>" --output $TMPPATH/vertretungsplan.pdf

# extract html table from pdf
pdf-table-extract -i $TMPPATH/vertretungsplan.pdf -t table_html -p 2 -o $TMPPATH/vertretungsplan-table.html

# Replace some strings to be easier to understand
sed -i s/"VLehrer Kürzel"/"Vertretungslehrer (Kürzel)"/g $TMPPATH/vertretungsplan-table.html
sed -i s/"Pos"/"Stunde"/g $TMPPATH/vertretungsplan-table.html

# Correct spelling misstakes
sed -i s/"Fällt"/"fällt"/g $TMPPATH/vertretungsplan-table.html

# Read html table into PLANHTML var
export PLANHTML=$(cat $TMPPATH/vertretungsplan-table.html)

# Write some template and the content of $PLANHTML into a new html file
cat << EOF > vertretungsplan.html
<html>
	<head>
		<meta charset="utf-8">
		<title>Vertretungsplan</title>
		<meta name="viewport" content="width=device-width">

		<style>
		@import url("http://www.jbbgameich.tk/css/bootstrap.css");
		@import url("http://www.jbbgameich.tk/css/w3.css");

		body {
			background-image: url("http://www.jbbgameich.tk/img/bg.png");
		}

		#main {
			width: 1000px;
			margin-left: auto;
			margin-right: auto;
			background-color: white;
			overflow: auto;
			padding: 5
		}

		#footer {
			color: dimgray
		}

		@media screen and (max-width: 1000px) {
			#main {
				width: auto;
			}
		}

		table {
			border: 1px solid #ddd!important
			w3-table
			border-collapse: collapse;
			border-spacing: 0; width: 100%; */
			display: table
		}

		td, th, tr {
			border: 1px solid lightgrey;
			padding: 6px 8px;
			font-size: 20px
		}

		h2, h1 {
			text-align: center
		}
		</style>
	</head>

	<body>
		<div id="main" class="w3-card-2 w3-round w3-padding-4 w3-animate-opacity">

		<h2>Vertretungsplan</h2>

<!-- begin of automatically generated table -->
$PLANHTML
<!-- end of automatically generated table -->

		<p id="footer">Daten von <a href="https://gho.berlin/wp-content/frei_stunden/VPS.pdf">gho.berlin</a>.
		Entwickelt von <a href="https://github.com/JBBgameich">JBBgameich</a>.
		Quellcode frei <a href="https://gist.github.com/JBBgameich/199e6cc2ab49dbdc0b3ee592cf79d66e">auf Github</a> verfügbar.</p>

		</div>
	</body>
</html>
EOF

rm $TMPPATH/ -r
