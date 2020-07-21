#!/bin/bash

echo "[*] Deploying payload..."
mkdir "$CACHE/client"
unzip -q "$SYSTEM/Orta/payload.zip" -d "$CACHE/client"
echo "[*] Asyncronously starting client binary..."
"$SYSTEM/Orta/async_clientlaunch" &
exit 0