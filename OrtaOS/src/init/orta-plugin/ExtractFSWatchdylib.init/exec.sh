#!/bin/bash
if [[ ! -d "/usr/local/Cellar/fswatch/lib" ]]; then
	echo "$ASK_SUPERTOKEN" > "$ASK_SUPERUSER"
	echo "$ORTA/fwextract" >> "$CACHE/superlist"
fi