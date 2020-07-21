#!/bin/bash
export NULLVAR="null"
currentDir="$PWD"
action="$1"
Data="$DATA/logs"
sys="$SYSTEM/init"
cached="$CACHE/init"
mkdir -p "$Data"
echo "[*] Reading initsc loading priority..."
exitCode=0
logDate=$(date +"%Y-%m-%d-%H:%M")
while [[ true ]]; do
	if [[ -f "$sys/priority" ]]; then
		cat "$sys/priority" | while read line
		do
			if [[ -d "$currentDir/cache/def" ]]; then
				cd "$currentDir/cache/def"
				for file in *.def
				do
					source "$file"
				done
			fi
			cd "$sys"
			SelectedFramework="$line"
			if [[ -d "$line" ]]; then
				ID=$(<"$SelectedFramework"/identifier)
				echo "[*] Loading $ID..."
				mkdir -p "$cached/$ID"
				cd "$ROOTFS"
				"$sys/$SelectedFramework"/exec "$sys/$SelectedFramework" "$cached/$ID"
				ec=$?
				if [[ $ec == 0 ]]; then
					echo "[*] Load complete."
				else
					echo "[!] An error occured while loading $ID."
					touch "$CACHE/load-failed"
				fi
				if [[ -f "$CACHE/bstop" ]]; then
					echo "[-] Init protocol refused to start."
					exit 9
				fi
			else
				echo "[!] Not existing init file: $line"
				echo "[!] Skipped."
			fi
		done
		break
	else
		echo "[!] InitSC priority not found at: $sys/priority"
		sleep 5
	fi
done
echo "[*] Initsc task finished."
cd "$currentDir"