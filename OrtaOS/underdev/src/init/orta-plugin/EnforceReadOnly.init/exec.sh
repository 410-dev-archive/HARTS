#!/bin/bash
touch "$SYSTEM/fswritable" 2>/dev/null
if [[ -f "$SYSTEM/fswritable" ]]; then
	echo "[-] System is writable."
	echo "Security layer files can be overwritten." > "/tmp/HARTS/orta-error"
	touch "$CACHE/bstop"
fi
exit 0