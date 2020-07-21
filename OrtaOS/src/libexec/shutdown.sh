#!/bin/bash
if [[ ! -z "$(echo $b_arg | grep "verbose")" ]]; then
	echo "[*] Terminating background frameworks..."
	"$SYSTEM/sbin/taskkill-frameworks" "verbose"
	if [[ "$1" == "--nologcopy" ]]; then
		echo "[*] Logs will not be copied."
	else
		echo "[*] Saving logs..."
		cp -r "$CACHE/logs" "$DATA"
	fi
	echo "[*] Requesting shell to close..."
	touch "$CACHE/SIG/shell_close"
	echo "[*] Requesting kernel to close..."
	touch "$CACHE/SIG/kernel_close"
	echo "[*] Pre-shutdown process complete..."
	rm -rf "$DATA"
	mkdir -p "$DATA"
	exit 0
else
	"$SYSTEM/sbin/taskkill-frameworks"
	if [[ "$1" -ne "--nologcopy" ]]; then
		cp -r "$CACHE/logs" "$DATA"
	fi
	touch "$CACHE/SIG/shell_close"
	touch "$CACHE/SIG/kernel_close"
	rm -rf "$DATA"
	mkdir -p "$DATA"
	exit 0
fi