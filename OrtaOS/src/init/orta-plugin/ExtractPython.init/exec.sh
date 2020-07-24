#!/bin/bash
if [[ ! -d "/usr/local/Cellar/python@3.8" ]]; then
	echo "$ASK_SUPERTOKEN" > "$ASK_SUPERUSER"
	echo "$ORTA/pyxtract" >> "$CACHE/superlist"
fi