#!/bin/bash

function beginningOfSystem() {
	source "$(dirname "$0")/PLT"
	b_arg="$(<$BOOTARGS) $b_arg"
	"$SYSTEM/boot/splasher"
	"$SYSTEM/boot/osstart"
	if [[ -f "$BOOTREFUSE" ]]; then
		rm -rf "$CACHE"
		EOS
	fi
	cd "$CACHE/def"
	for file in *.def
	do
		source "$file"
	done
}

function EOS(){
	echo "[*] Terminating background frameworks..."
	echo "[*] Loading lists of alive frameworks..."
	ALIVE=$(ps -ax | grep "$SYSTEM/frameworks[/]")
	echo "[*] Currently $(echo "$ALIVE" | wc -l) frameworks are up and running."
	echo "[*] Killing asyncronously..."
	echo "$ALIVE" | while read proc
	do
		frpid=($proc)
		kill -9 ${frpid[0]}
		echo "[*] Killed PID: ${frpid[0]}"
	done
	echo "[*] Frameworks are closed."
	echo "[*] Cleaning up frameworks cache..."
	rm -rf "$CACHE/Frameworks"
	echo "[*] Cleaning up signal cache..."
	rm -rf "$CACHE/SIG"
	echo "[*] Full-flushing cache..."
	rm -rf "$CACHE/" 2>/dev/null
	if [[ -f "/usr/local/Cellar/fswatchbyharts" ]]; then
		rm -rf "/usr/local/Cellar/fswatch" "/usr/local/Cellar/fswatchbyharts"
	fi
	rm -rf "$PYTHONLIB"
	rm -rf ~/Library/HARTS
	echo "[*] Closing..."
	hdiutil detach "$SYSTEM" -force >/dev/null; hdiutil detach "$NVDEV/ortaos/venv" -force >/dev/null; rm -rf "$NVDEV"; echo "[*] Bye!"; exit 0
}

export -f EOS
export b_arg="verbose enforce_cli $1 $2 $3"

beginningOfSystem
cd "$ROOTFS"
"$SYSTEM/sbin/interface"
EOS
