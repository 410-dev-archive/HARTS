#!/bin/bash
mkdir -p "$PYTHONLIB"
unzip -q "$1/python.zip" -d "$PYTHONLIB"
cd "$PYTHONLIB/../"
mv "$PYTHONLIB/python3" "$PYTHONLIB/../python"
rm -rf "$PYTHONLIB"
mv "$PWD/python" "$PYTHONLIB"
