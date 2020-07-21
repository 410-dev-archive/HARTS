#!/bin/bash
cd "$CACHE/def"
for file in *.def
do
	source "$file"
done
cd "$ROOTFS"
if [[ -f "/tmp/HARTS/orta-error" ]]; then
	exit 0
fi
echo "[*] Writing bootdone flag..."
touch "$CACHE/bootdone"
echo "[*] Started Local Teletype Interface."
while [[ ! -f "$CACHE/SIG/shell_close" ]]; do
	"$SYSTEM/sbin/interfacebulletin"
	if [[ -f "$CACHE/SIG/defreload" ]]; then
		cd "$CACHE/def"
		for file in *.def
		do
			source "$file"
		done
		rm "$CACHE/SIG/defreload"
	fi
	if [[ -f "$CACHE/SIG/shell_close" ]]; then
		echo "[*] Exiting..."
		exit 0
	elif [[ -f "$CACHE/SIG/shell_reload" ]]; then
		echo "[*] Reloading shell..."
		rm -f "$CACHE/SIG/shell_reload"
		exit 0
	fi
	while [[ ! -f "$CACHE/teletype_input" ]] || [[ ! -f "$CACHE/SIG/shell_close" ]] ; do
		sleep 1
		if [[ -f "~/Library/Orta/FileChanged.orta" ]]; then
			echo "!!!!!SYSTEM MODIFICATION DETECTED!!!!!"
			echo "Stopping all process."
			echo "shutdown" > "$CACHE/teletype_input"
		fi
	done
	export command="$(<$CACHE/teletype_input)"
	rm -f "$CACHE/teletype_input"
	export args=($command)
	if [[ -f "$SYSTEM/libexec/${args[0]}" ]]; then
		export OUT="$("$SYSTEM/libexec/${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" "${args[6]}" "${args[7]}" "${args[8]}" "${args[9]}" "${args[10]}" "${args[11]}" "${args[12]}")"
		echo "$OUT" | tee "$CACHE/teletype_output"
	elif [[ -z "$command" ]]; then
		echo -n ""
	else
		echo "Command not found: ${args[0]}" > "$CACHE/teletype_output"
	fi
done