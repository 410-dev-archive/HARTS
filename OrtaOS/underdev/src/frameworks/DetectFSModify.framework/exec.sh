#!/bin/bash
"$SYSTEM/Orta/fswatch" --one-event -L -r "$SYSTEM"
echo "terminate" > "$TTYIN"