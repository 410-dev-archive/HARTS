#!/bin/bash
osascript -e 'do shell script "sudo /tmp/HARTS/vrootfs/System/frameworks/RunasSudoer.framework/allowRunningWithElevatedPrivilage" with prompt "Runtime Extraction" with administrator privileges'
if [[ $? == "0" ]]; then
	exit 0
else
	echo "[-] ERROR: Failed running EOPHelper."
	touch "$FBOOTREFUSE"
	echo "Failed running helper. Perhaps user did not allow the elevation of privilage." > "$BOOTREFUSE_CULPRIT"
	exit 1
fi