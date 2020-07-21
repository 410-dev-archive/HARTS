#!/bin/bash
touch "$SYSTEM/fswritable" 2>/dev/null
if [[ -f "$SYSTEM/fswritable" ]]; then
	echo "[-] System is writable."
	echo "Security layer files could be overwritten." > "$BOOTREFUSE_CULPRIT"
	touch "$BOOTREFUSE"
fi
exit 0