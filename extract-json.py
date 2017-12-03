#!/usr/bin/python3
import json
import pdftableextract as pdf
import requests
from requests.auth import HTTPBasicAuth
import sys
import os
import datetime

PDF_URL = "https://gho.berlin/wp-content/frei_stunden/VPS.pdf"
PDF_FILE_NAME = "vertretungsplan.pdf"

class JsonObject:
    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
            sort_keys=True, indent=4)

# download url to given file name; if no name given use name from URL
# chunk size defaults to 1 KiB
def downloadFile(url, auth, fname = None, chunkSize = 1024):
    if not fname:
        fname = url.split('/')[-1]

    response = requests.get(url, auth=auth, stream=True)

    # download each chunk and save to file
    with open(fname, 'wb') as f:
        for chunk in response.iter_content(chunk_size=chunkSize):
            if chunk: # filter out keep-alive new chunks
                f.write(chunk)
    # return the file name (only useful, if name was get from url)
    return fname

def extractCellsFromPdf(fname):
    pages = ["2"]
    cells = [pdf.process_page(PDF_FILE_NAME, p) for p in pages]

    # flatten the cells structure
    cells = [item for sublist in cells for item in sublist]
    cells = pdf.table_to_list(cells, pages)[2]

    return cells

def convertCellsToJson(cellsList, dlTime):
    json = JsonObject()
    json.lastUpdated = dlTime.strftime("%Y-%m-%dT%H:%M")
    json.data = []

    for i in range(0, len(cellsList)):
        cell = cellsList[i]

        # ignore cell if has not enough fields
        #                is header
        #                all fields are empty
        if len(cell) < 7 or "Pos" in cell[0] or cell[1:] == cell[:-1]:
            continue

        jObj = JsonObject()
        jObj.lesson = cell[0]; jObj.course = cell[1]; jObj.subject = cell[2]
        jObj.room = cell[3]; jObj.teacher = cell[4]; jObj.note = cell[5]
        jObj.type = cell[6]

        json.data.append(jObj)
        print(cell)

    print(json.toJSON())
    return json.toJSON()

def main(username, password):
    # get current time needed later for 'lastUpdated' in JSON
    dlTime = datetime.datetime.now()
    # download Vertretungsplan pdf
    downloadFile(PDF_URL, HTTPBasicAuth(username, password), fname = PDF_FILE_NAME)
    # extract JSON from pdf table
    cells = extractCellsFromPdf(PDF_FILE_NAME)
    # delete pdf file
    os.remove(PDF_FILE_NAME)
    # build json
    json = convertCellsToJson(cells, dlTime)

if __name__ == "__main__":
    # arguments
    if len(sys.argv) < 3:
        print("No username or password given!")
        print("Usage: " + sys.argv[0] + " USERNAME PASSWORD")
        exit(1)

    main(sys.argv[1], sys.argv[2])
