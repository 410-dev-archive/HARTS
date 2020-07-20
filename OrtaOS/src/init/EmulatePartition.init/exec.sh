#!/bin/bash
echo "[*] Generating emulated partitions..."
echo "[*] Setting emulated0=DATA..."
mkdir -p "$DATA"
echo "[*] Setting emulated1=USERDATA..."
mkdir -p "$USERDATA"
echo "[*] Setting emulated2=MULTIPLEX..."
mkdir -p "$MULTIPLEX"
echo "[*] Copying tree to emulated2..."
cp -r "$1/emulated2" "$ROOTFS"
exit 0