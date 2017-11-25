#!/bin/bash

function gen_from_html_template {
	cat << EOF > $TARGET
	<html>
		<head>
			<meta charset="utf-8">
			<title>$TITLE</title>
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

			<h2>$TITLE</h2>

			<p align="right">Zuletzt aktualisiert am $GENTIME</p>

	<!-- begin of automatically generated table -->
	$HTML
	<!-- end of automatically generated table -->

			<p id="footer">Daten von <a href="$SOURCE">gho.berlin</a>.
			Entwickelt von <a href="https://github.com/JBBgameich">JBBgameich</a>.
			Quellcode frei <a href="https://gist.github.com/JBBgameich/199e6cc2ab49dbdc0b3ee592cf79d66e">auf Github</a> verfügbar.</p>

			</div>
		</body>
	</html>
EOF
}
