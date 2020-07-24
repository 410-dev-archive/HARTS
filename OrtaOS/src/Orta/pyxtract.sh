#!/bin/bash
echo "[*] Extracting python..."
mkdir -p "/usr/local/Cellar"
unzip -q "$ORTA/python.zip" -d "/usr/local/Cellar"
rm -rf "/usr/local/Cellar/__MACOSX"
touch "/usr/local/Cellar/pythonbyharts"