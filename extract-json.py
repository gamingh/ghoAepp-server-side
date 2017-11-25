#!/usr/bin/python3

import json
import pdftableextract as pdf
import requests
from requests.auth import HTTPBasicAuth
import os
import datetime

# Get current date and time:
gentime = datetime.datetime.now()

# Querry server with authentification
pdfurl = "https://gho.berlin/wp-content/frei_stunden/VPS.pdf"
response = requests.get(pdfurl, auth=HTTPBasicAuth("<username>", "<password>"))
pdffilename = "vertretungsplan.pdf"

# extract table
outputfile = open(pdffilename, "wb")
outputfile.write(response.content)
outputfile.close

pages = ["2"]
cells = [pdf.process_page(pdffilename, p) for p in pages]

os.remove(pdffilename)

# flatten the cells structure
cells = [item for sublist in cells for item in sublist ]

li = pdf.table_to_list(cells, pages)[2]

# Write Json into file
jsonfilename = "vertretungsplan.json"

if os.path.isfile(jsonfilename):
    # Remove old versions of the file
    os.remove(jsonfilename)

jsonfile = open(jsonfilename, "w")
jsonfile.write(json.dumps({"lastUpdated": gentime.strftime("%Y-%m-%d %H:%M"), "table": li}, sort_keys=True, indent=4))
jsonfile.close
