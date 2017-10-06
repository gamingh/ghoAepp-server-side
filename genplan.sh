#!/bin/bash
# Depends on https://github.com/ashima/pdf-table-extract and curl

export ROOTPWD=$(pwd)

# Create new temp folder
mkdir -p /tmp/vertretungsplan; cd /tmp/vertretungsplan

# Download pdf with authentification
curl https://gho.berlin/wp-content/frei_stunden/VPS.pdf --user "<username>:<password>" --output vertretungsplan.pdf

# extract html table from pdf
pdf-table-extract -i vertretungsplan.pdf -t table_html -p 2 -o vertretungsplan-table.html

# Read html table into PLANHTML var
export PLANHTML=$(cat vertretungsplan-table.html)

# Write some template and the content of $PLANHTML into a new html file
cat << EOF > $ROOTPWD/vertretungsplan.html
<html>
	<head>
		<meta charset="utf-8">
		<title>Vertretungsplan</title>
		<meta name="viewport" content="width=device-width">
	</head>

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
	}

	@media screen and (max-width: 1000px) {
		#main {
			width: 100%;
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
	</style>

	<body>
		<div id="main" class="w3-card-2 w3-round w3-padding-4 w3-animate-opacity">

<!-- begin of automatically generated table -->
$PLANHTML
<!-- end of automatically generated table -->

		</div>
	</body>
</html>
EOF

cd ..; rm vertretungsplan -r
cd $ROOTPWD
