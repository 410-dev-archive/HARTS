#!/bin/bash
"$SYSTEM/sendpacket" "teacher" "report" "commandEvent=$1"
echo "$1" > "$CACHE/commandEvent"