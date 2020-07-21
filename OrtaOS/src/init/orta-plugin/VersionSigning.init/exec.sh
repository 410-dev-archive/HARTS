#!/bin/bash

function operatorVersion() {
	echo "$(<$SYSTEM/init/TDOSProfiler.init/sys_version)"
}

function operatorBuild() {
	echo "$(<$SYSTEM/init/TDOSProfiler.init/sys_build)"
}

echo "[*] Checking remote signature..."
echo "[*] Connecting to server..."
export content="$(curl -Ls https://raw.githubusercontent.com/cfi3288/HARTS-Signing-Server/master/sgType1/signed)"
if [[ ! -z "$(echo $(<$BOOTARGS) | grep "NO_SIGNING")" ]]; then
	echo "[*] Debug."
elif [[ -z "$(echo $content | grep "$(operatorVersion),")" ]]; then
	echo "[-] Unsinged version."
	echo "[-] Security component disallowed system startup."
	echo "Security layer version signature is invalid." > "$BOOTREFUSE_CULPRIT"
	touch "$BOOTREFUSE"
	exit 0
else
	echo "[*] This version ($(operatorVersion)) is signed by remote server."
fi
if [[ ! -z "$(echo $(<$BOOTARGS) | grep "NO_SIGNING")" ]]; then
	echo "[*] Debug."
elif [[ -z "$(echo $content | grep "build=$(operatorBuild)")" ]] && [[ -z "$(echo $content | grep "build=all")" ]]; then
	echo "[-] Unsigned Build."
	echo "[-] Security component disallowed system startup."
	echo "Security layer build signature is invalid." > "$BOOTREFUSE_CULPRIT"
	touch "$BOOTREFUSE"
	exit 0
else
	echo "[*] This build ($(operatorBuild)) is signed by remote server."
fi
