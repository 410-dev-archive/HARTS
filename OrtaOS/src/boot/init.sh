#!/bin/bash
source "$(dirname "$0")/PLT"
export b_arg="verbose enforce_cli $1 $2 $3 $4 $5 $6"
"$SYSTEM/boot/splasher"
"$SYSTEM/boot/osstart"
cd "$CACHE/def"
for file in *.def
do
	source "$file"
done
if [[ -f "$CACHE/bstop" ]]; then
	"$SYSTEM/libexec/shutdown"
	rm -rf "$CACHE/Frameworks"
	rm -rf "$CACHE/SIG"
	rm -rf "$CACHE/" 2>/dev/null
	hdiutil detach "$SYSTEM" -quiet -force 2>/dev/null
	rm -rf "$ROOTFS"
	exit 9
fi
cd "$ROOTFS"
while [[ true ]]; do
	"$SYSTEM/sbin/interface"
	if [[ -f "$CACHE/SIG/kernel_close" ]]; then
		echo "[*] Kernel close signal detected."
		echo "[*] Running self-destruction..."
		break
	fi
done
if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
	echo "[*] Cleaning up frameworks cache..."
	rm -rf "$CACHE/Frameworks"
	echo "[*] Cleaning up signal cache..."
	rm -rf "$CACHE/SIG"
	echo "[*] Full-flushing cache..."
	rm -rf "$CACHE/" 2>/dev/null
	hdiutil detach "$SYSTEM" -quiet -force 2>/dev/null
	hdiutil detach "$SYSTEM/../venv" -quiet -force 2>/dev/null
	echo "[*] Closing..."
	echo "[*] Goodbye from kernel!"
	rm -rf "$ROOTFS"; exit 0
else
	rm -rf "$CACHE/Frameworks"
	rm -rf "$CACHE/SIG"
	rm -rf "$CACHE/" 2>/dev/null
	hdiutil detach "$SYSTEM" -quiet -force 2>/dev/null
	hdiutil detach "$SYSTEM/../venv" -quiet -force 2>/dev/null
	rm -rf "$ROOTFS"; exit 0
fi