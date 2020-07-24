#!/bin/bash
if [[ "$1" == "teacher" ]]; then
	"$PYTHON" "$ORTA/server-host.py" "$2 $3 $4 $5 $6 $7 $8 $9"
elif [[ "$1" == "master" ]]; then
	"$PYTHON" "$ORTA/server-master.py" "$2 $3 $4 $5 $6 $7 $8 $9"
fi