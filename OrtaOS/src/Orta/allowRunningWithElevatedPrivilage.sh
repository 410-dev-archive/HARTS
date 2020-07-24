#!/bin/bash
source "/tmp/HARTS/ortaos/vrootfs/System/boot/PLT"
echo "[*] Sourced partition map."
while [[ true ]]; do
	if [[ -f "$CACHE/superlist" ]]; then
		echo "[*] Detected request!"
		cat "$CACHE/superlist" | while read command
		do
			echo "[*] Running: $command"
			sudo "$command"
		done
		echo "[*] Request done."
		rm -f "$CACHE/superlist"
		rm -f "$ASK_SUPERUSER"
	fi
	sleep 5
done