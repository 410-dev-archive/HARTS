#!/bin/bash
mkdir -p ~/Library/HARTS
unzip -q "$1/python.zip" -d ~/Library/HARTS
rm -rf ~/Library/HARTS/__MACOSX
exit 0