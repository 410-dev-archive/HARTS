#!/bin/bash
export output=$(system_profiler SPHardwareDataType | awk '/Model Identifier/ {print $3}')
export isVM="0"
if [[ ! -z "$(echo $output | grep VM)" ]] || [[ ! -z "$(echo $output | grep Virtual)" ]] || [[ ! -z "$(echo $output | grep Parallels)" ]]; then
	export isVM="1"
fi
if [[ "$isVM" == "1" ]]; then
	echo "[-] System is running on virtual machine."
	touch "$CACHE/bstop"
fi
exit 0