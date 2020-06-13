#!/bin/bash
touch "/tmp/TESTDONE.harts"
while [[ ! -z $(ps -ax | grep "[l]ockvf") ]]; do
	touch "/tmp/TESTDONE.harts"
	sleep 1
fi
sleep 3
if [[ -z $(ps -ax | grep "/System/Library/CoreServices/[F]inder") ]]; then
	#Test required
	/System/Library/CoreServices/Finder.app/Contents/MacOS/Finder &
fi
rm "/tmp/TESTDONE.harts"