#!/bin/bash
if [[ -d "/usr/local/Cellar/fswatch/lib" ]]; then
	mkdir -p "/usr/local/Cellar"
	cp "$1/fswatch" "/usr/local/Cellar/"
	touch "/usr/local/Cellar/fswatchbyharts"
fi