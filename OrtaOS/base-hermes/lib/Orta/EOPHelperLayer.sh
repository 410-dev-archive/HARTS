#!/bin/bash
source "/tmp/HARTS/ortaos/vrootfs/System/boot/PLT"
touch "$CACHE/sudostart"

# Extract FSWatch library
if [[ ! -d "/usr/local/Cellar/fswatch" ]]; then
	echo "Extracting fswatch"
	mkdir -p "/usr/local/Cellar"
	unzip -q "$ORTA/fswatch.zip" -d "/usr/local/Cellar"
	rm -rf "/usr/local/Cellar/__MACOSX"
	chown -R "$(<"$CACHE/username")" "/usr/local/Cellar/fswatch"
fi

# Extract Python
if [[ ! -d "/usr/local/Cellar/python@3.8" ]]; then
	echo "Extracting python"
	mkdir -p "/usr/local/Cellar"
	unzip -q "$ORTA/python-wpip.zip" -d "/usr/local/Cellar"
	rm -rf "/usr/local/Cellar/__MACOSX"
	chown -R "$(<"$CACHE/username")" "/usr/local/Cellar/python@3.8"
fi

exit 0