#!/bin/bash
while [[ true ]]; do
	sleep 10
	export ps="$(ps -ax | grep "HART[S] Student")"
	if [[ -z "$ps" ]]; then
		if [[ ! -f "$TTYIN" ]] && [[ -z "$(cat "$TTYIN" | grep "test_done")" ]]; then
			echo "terminate" >> "$TTYIN"
			exit 0
		fi
	fi
done