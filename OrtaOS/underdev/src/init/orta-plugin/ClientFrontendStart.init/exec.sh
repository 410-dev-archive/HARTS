#!/bin/bash
echo "[*] Deploying payload..."
mkdir "$CACHE/client"
unzip -q "$ORTA/payload.zip" -d "$CACHE/client"
echo "[*] Asyncronously starting client binary..."
"$CACHE/client/HARTS Student.app/Contents/MacOS/HARTS Student" &
exit 0