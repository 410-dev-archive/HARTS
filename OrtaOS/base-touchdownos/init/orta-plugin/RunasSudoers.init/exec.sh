#!/bin/bash
osascript -e 'do shell script "sudo bash -c /tmp/HARTS/ortaos/vrootfs/System/Orta/EOPHelperLayer" with prompt "Higher privilage is required to launch the framework." with administrator privileges'
if [[ $? == "0" ]]; then
	exit 0
else
	echo "[-] ERROR: Failed running EOPHelper."
	touch "$BOOTREFUSE"
	echo "Failed running helper. Perhaps user did not allow the elevation of privilage." > "$BOOTREFUSE_CULPRIT"
	exit 1
fi