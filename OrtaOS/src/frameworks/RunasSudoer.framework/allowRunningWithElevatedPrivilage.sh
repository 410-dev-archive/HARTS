#!/bin/bash
while [[ true ]]; do
	if [[ -f "$ASK_SUPERUSER" ]]; then
		ARGS=($(<"$ASK_SUPERUSER"))
		if [[ "${ARGS[0]}" == "$ASK_SUPERTOKEN" ]]; then
			if [[ -f "$CACHE/superlist" ]]; then
				cat "$CACHE" | while read command
				do
					LineArgs=($command)
					sudo "${LineArgs[0]}" "${LineArgs[1]}" "${LineArgs[2]}" "${LineArgs[3]}" "${LineArgs[4]}" "${LineArgs[5]}" "${LineArgs[6]}"
				done
				rm -f "$CACHE/superlist"
			else
				sudo "${ARGS[1]}" "${ARGS[2]}" "${ARGS[3]}" "${ARGS[4]}" "${ARGS[5]}" "${ARGS[6]}"
				rm -f "$ASK_SUPERUSER"
			fi
		fi
	fi
	sleep 5
done