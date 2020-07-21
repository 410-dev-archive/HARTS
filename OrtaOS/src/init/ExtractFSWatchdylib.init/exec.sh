#!/bin/bash
if [[ ! -d "/usr/local/Cellar/fswatch/lib" ]]; then
	if [[ ! -d "/usr/local/Cellar" ]]; then
		echo "$(whoami)" > /tmp/uname
		osascript -e 'do shell script "mkdir -p /usr/local/Cellar; chown -R $(</tmp/uname) /usr/local/Cellar" with prompt "Runtime Extraction" with administrator privileges'
	fi
	cp -r "$1/fswatch" "/usr/local/Cellar/"
	touch "/usr/local/Cellar/fswatchbyharts"
fi

# if [[ ! -d "/usr/local/Cellar/fswatch/lib" ]]; then
# 	echo "Library deployment failed." > "/tmp/HARTS/orta-error"
# 	echo "[-] Failed deploying fswatch library."
# 	touch "$CACHE/bstop"
# fi