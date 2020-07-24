#!/bin/bash
if [[ ! -d "/usr/local/Cellar/python@3.8" ]]; then
	echo "$ASK_SUPERTOKEN" > "$ASK_SUPERUSER"
	echo "mkdir -p /usr/local/Cellar" >> "$CACHE/superlist"
	echo "chown -R $(whoami) /usr/local/Cellar" >> "$CACHE/superlist"
	echo "unzip -q \"$1/python.zip\" -d \"/usr/local/Cellar\"" >> "$CACHE/superlist"
	echo "rm -rf \"/usr/local/Cellar/__MACOSX\"" >> "$CACHE/superlist"
	echo "chown -R $(whoami) /usr/local/Cellar/python@3.8" >> "$CACHE/superlist"
	echo "touch \"/usr/local/Cellar/pythonbyharts\"" >> "$CACHE/superlist"
fi