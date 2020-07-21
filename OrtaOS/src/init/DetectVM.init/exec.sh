#!/bin/bash
export output=$(system_profiler SPHardwareDataType | awk '/Model Identifier/ {print $3}')
export isVM="0"
if [[ ! -z "$(echo $output | grep VM)" ]] || [[ ! -z "$(echo $output | grep Virtual)" ]] || [[ ! -z "$(echo $output | grep Parallels)" ]]; then
	export isVM="1"
fi
if [[ ! -z "$(echo $(</tmp/HARTS/bootarg) | grep "NO_VM_DETECTION")" ]]; then
	export isVM="0"
fi
if [[ "$isVM" == "1" ]]; then
	echo "[-] System is running on virtual machine."
	echo "Detected virtual machine." > "/tmp/HARTS/orta-error"
	touch "$CACHE/bstop"
fi
exit 0