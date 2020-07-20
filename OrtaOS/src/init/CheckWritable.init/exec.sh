#!/bin/bash
touch "$SYSTEM/isWritable"
if [[ $? == 0 ]] || [[ -f "$SYSTEM/isWritable" ]]; then
	touch "$CACHE/bstop"
	echo "[-] System partition is writable."
fi
exit 0