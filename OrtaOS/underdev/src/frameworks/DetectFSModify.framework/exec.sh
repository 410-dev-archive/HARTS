#!/bin/bash
if [[ -e "/usr/local/Cellar/fswatch/1.14.0/lib/libfswatch.11.dylib" ]]; then
	"$ORTA/fswatch" --one-event -L -r "$SYSTEM"
	echo "terminate" > "$TTYIN"
fi