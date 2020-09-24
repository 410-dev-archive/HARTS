#!/bin/bash
while [[ ! -e "/usr/local/Cellar/fswatch/1.14.0/lib/libfswatch.11.dylib" ]]; do
	echo -n ""
	sleep 1
done
"$ORTA/fswatch" --one-event -L -r "$SYSTEM"
echo "terminate" > "$TTYIN"