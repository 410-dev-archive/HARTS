#!/bin/bash
"$PYTHON" "$SYSTEM/Orta/teacherconnect.py" "report" "commandEvent=$1"
echo "$1" > "$CACHE/commandEvent"