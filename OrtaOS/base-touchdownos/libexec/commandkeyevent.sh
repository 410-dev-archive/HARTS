#!/bin/bash
"$SYSTEM/sendpacket" "teacher" "KEYEVENT:$(<$CACHE/username):$1"
echo "$1" > "$CACHE/commandEvent"