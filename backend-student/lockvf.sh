#!/bin/bash
while [[ -f "/tmp/TESTDONE.harts" ]]; do
        sleep 1
        export dtcfndr=$(ps -ax | grep "/System/Library/CoreServices/[F]inder")
        if [[ -z "$dtcfndr" ]]; then
                touch "/tmp/FINDER_STARTED.harts"
        fi
done
