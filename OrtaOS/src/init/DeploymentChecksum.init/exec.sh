#!/bin/bash
echo "[*] Calculating SHA512..."
export PAYLOAD_PATH="$SYSTEM/Orta/payload.zip"
export checksum=($(shasum -a 512 "$PAYLOAD_PATH"))
checksum=${checksum[0]}
curl -Ls "https://raw.githubusercontent.com/cfi3288/HARTS-Signing-Server/master/sgType1/payload512" -o "$CACHE/checksum"
if [[ "$checksum" == "$(<$CACHE/checksum)" ]]; then
	echo "[*] Checksum pass."
	rm "$CACHE/checksum"
else
	echo "[-] Checksum does not match with expected checksum."
	echo "[-] Expected: $checksum"
	echo "Failed verifying client integrity." > "/tmp/HARTS/orta-error"
	touch "$CACHE/bstop"
fi
exit 0