#!/bin/bash
touch "$CACHE/bootdone"
echo "[*] Started TTY Interface."
cd "$CACHE/def"
for file in *.def
do
	source "$file"
done
cd "$ROOTFS"
export logSuffix="$(<"$CACHE/SESSION_NUM")"
while [[ true ]]; do
	cd "$ROOTFS"
	while [[ ! -f "$TTYIN" ]]; do
		sleep 2
	done
	args=($(cat "$TTYIN"))
	if [[ -f "$SYSTEM/libexec/${args[0]}" ]]; then
		echo "[IN] [$(date +"%Y-%m-%d %H:%M")] COMMAND ENTERED: $command" >> "$LIB/Logs/INTERFACE_$logSuffix.tlog"
		echo "[OUT-START]" >> "$LIB/Logs/INTERFACE_$logSuffix.tlog"
		"$SYSTEM/libexec/${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" "${args[6]}" "${args[7]}" "${args[8]}" "${args[9]}" "${args[10]}" "${args[11]}" "${args[12]}" | tee -a "$LIB/Logs/INTERFACE_$logSuffix.tlog" | tee "$TTYOUT"
		echo "[OUT-END]" >> "$LIB/Logs/INTERFACE_$logSuffix.tlog"
		rm -f "$TTYIN"
	elif [[ -z "$command" ]]; then
		echo -n ""
	else
		echo "Command not found: ${args[0]}"
	fi
	if [[ -f "$CACHE/SIG/shell_close" ]]; then
		echo "[*] Exiting..."
		exit 0
	fi
done