#!/bin/bash
mkdir -p "~/Library/HARTS/python3"
unzip -q "$1/python.zip" -d "~/Library/HARTS/python3"
mv "~/Library/HARTS/python3/python3" "~/Library/HARTS/python32"
rm -rf "~/Library/HARTS/python3"
mv "~/Library/HARTS/python32" "~/Library/HARTS/python3"
