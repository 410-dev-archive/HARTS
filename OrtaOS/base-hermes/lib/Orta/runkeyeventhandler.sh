#!/bin/bash
while [[ true ]]; do
	"$PYTHON" "$ORTA/keyevent.py"
	export exitk=$?
	if [[ $exitk == 0 ]] || [[ $exitk == 143 ]]; then
		break
	fi
	sleep 5
done
