#!/bin/bash
echo "[*] Deploying payload..."
mkdir "$CACHE/client"
unzip -q "$ORTA/payload.zip" -d "$CACHE/client"
echo "[*] Asyncronously starting client binary..."
"$ORTA/clientlaunch" &
exit 0