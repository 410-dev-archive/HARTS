#!/bin/bash
touch "/tmp/TESTDONE.harts"
while [[ ! -z $(ps -ax | grep "[l]ockvf") ]]; do
	echo "" > "/tmp/TESTDONE.harts"
	sleep 1
done
sleep 3
if [[ -z $(ps -ax | grep "/System/Library/CoreServices/[F]inder") ]]; then
	#Test required
	# /System/Library/CoreServices/Finder.app/Contents/MacOS/Finder &
	open /System/Library/CoreServices/Finder.app
fi
"$ORTALIB/launchdmgr-s"
"$ORTALIB/"
rm "/tmp/TESTDONE.harts"
"$SYSTEM/libexec/shutdown"