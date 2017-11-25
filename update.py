#!/usr/bin/python3
import subprocess

print("Extracting HTML ...")
subprocess.call(["bash", "extract-html.sh"], shell=False)

print("Extracting JSON ...")
subprocess.call(["python3", "extract-json.py"], shell=False)
