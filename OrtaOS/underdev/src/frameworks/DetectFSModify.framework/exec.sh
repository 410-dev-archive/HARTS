#!/bin/bash
"$ORTA/fswatch" --one-event -L -r "$SYSTEM"
echo "terminate" > "$TTYIN"