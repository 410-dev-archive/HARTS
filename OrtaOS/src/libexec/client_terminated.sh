#!/bin/bash
export CrashReportPath="$CACHE/onrunclient/crashlog"
if [[ -f "$CrashReportPath" ]]; then
	echo "[-] There is a crash report: "
	cat "$CrashReportPath"
fi
echo "[*] Sending shutdown command over teletype..."
echo "shutdown" > "$CACHE/teletype_input"
