#!/bin/bash
while [[ true ]]; do
	sleep 10
	export ps="$(ps -ax | grep "HART[S] Student")"
	if [[ -z "$ps" ]]; then
		echo "terminate" > "$TTYIN"
		exit 0
	fi
done