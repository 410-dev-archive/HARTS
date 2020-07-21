#!/bin/bash
if [[ ! -d "/usr/local/Cellar/fswatch/lib" ]]; then
	if [[ ! -d "/usr/local/Cellar" ]]; then
		echo "$(whoami)" > /tmp/uname
		osascript -e 'do shell script "mkdir -p /usr/local/Cellar; chown -R $(</tmp/uname) /usr/local/Cellar" with prompt "Runtime Extraction" with administrator privileges'
	fi
	mkdir -p "/usr/local/Cellar/fswatch"
	unzip -q "$1/fswatch.zip" -d "/usr/local/Cellar"
	touch "/usr/local/Cellar/fswatchbyharts"
fi