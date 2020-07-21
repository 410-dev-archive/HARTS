#!/bin/bash

echo "[*] Deploying payload..."
mkdir "$CACHE/client"
unzip -q "$ORTA/payload.zip" -d "$CACHE/client"
echo "[*] Asyncronously starting client binary..."
"$ORTA/async_clientlaunch" &
exit 0