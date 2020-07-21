#!/bin/bash
export NULLVAR="null"
mkdir -p "$CACHE/SIG"
echo "[*] Running initiation script..."
"$SYSTEM/sbin/initsc"
if [[ -f "$CACHE/bstop" ]]; then
	echo "System bootup interrupted. Stopping boot process."
	exit 9
fi
cd "$CACHE/def"
for file in *.def
do
	source "$file"
done
cd "$ROOTFS"
echo "[*] Running frameworks asyncronously..."
mkdir -p "$CACHE/frameworks"
"$SYSTEM/sbin/frameworks" --load
if [[ -f "$CACHE/update-complete" ]]; then
	echo "[*] Update complete."
	rm -f "$CACHE/update-complete"
elif [[ -f "$CACHE/load-failed" ]]; then
	rm -f "$CACHE/load-failed"
	echo "[!] Framworks loader returned non-zero exit code."
	echo "[!] Unable to continue!"
	while [[ true ]]; do
		sleep 1000
	done
else
	echo "[*] Frameworks loaded without problem."
	echo "[*] Starting Interface..."
fi