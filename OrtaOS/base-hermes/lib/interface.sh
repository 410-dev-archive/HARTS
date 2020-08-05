#!/bin/bash
if [[ -f "$BOOTREFUSE" ]]; then
	"$SYSTEM/bin/terminate"
	exit 0
fi
touch "$CACHE/bootdone"
echo "[*] Started TTY Interface."
cd "$ROOTFS"
while [[ true ]]; do
	cd "$ROOTFS"
	while [[ ! -f "$TTYIN" ]]; do
		sleep 2
	done
	args=($(cat "$TTYIN"))
	if [[ -f "$SYSTEM/bin/${args[0]}" ]]; then
		"$SYSTEM/bin/${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" "${args[6]}" "${args[7]}" "${args[8]}" "${args[9]}" "${args[10]}" "${args[11]}" "${args[12]}"
		rm -f "$TTYIN"
	elif [[ -z "$command" ]]; then
		echo -n ""
	else
		echo "Command not found: ${args[0]}"
	fi
	if [[ -f "$CACHE/shell_close" ]]; then
		echo "[*] Exiting..."
		exit 0
	fi
done