#!/bin/bash
echo "[*] Generating emulated partitions..."
mkdir -p "$EMUDISK"
mkdir -p "$DATA"
mkdir -p "$CACHE"
mkdir -p "$CACHE/SIG"
mkdir -p "$LIB/Logs"
echo "[*] Writing multiplex..."
cp -r "$TDLIB/defaults/multiplex" "$DATA"
mv "$DATA/multiplex" "$DATA/config"
exit 0