#!/bin/bash
touch "$SYSTEM/fswritable" 2>/dev/null
if [[ -f "$SYSTEM/fswritable" ]]; then
	echo "[-] System is writable."
	touch "$CACHE/bstop"
fi
exit 0