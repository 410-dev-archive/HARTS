#!/bin/bash
echo "$ASK_SUPERTOKEN" > "$ASK_SUPERUSER"
echo "$PYTHON \"$1/keyevent.py\"" >> "$CACHE/superlist"