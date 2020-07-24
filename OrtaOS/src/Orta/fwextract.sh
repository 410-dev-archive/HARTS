#!/bin/bash
echo "mkdir -p /usr/local/Cellar" >> "$CACHE/superlist"
echo "chown -R $(whoami) /usr/local/Cellar" >> "$CACHE/superlist"
echo "mkdir -p /usr/local/Cellar/fswatch" >> "$CACHE/superlist"
echo "unzip -q \"$1/fswatch.zip\" -d \"/usr/local/Cellar\"" >> "$CACHE/superlist"
echo "rm -rf \"/usr/local/Cellar/__MACOSX\"" >> "$CACHE/superlist"
echo "touch \"/usr/local/Cellar/fswatchbyharts\"" >> "$CACHE/superlist"