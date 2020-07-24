#!/bin/bash
if [[ ! -f ~/Library"/Python/3.8/lib/python/sites-packages/pynput/__init__.py" ]]; then
	touch "$CACHE/depinstall"
fi
while [[ ! -f ~/Library"/Python/3.8/lib/python/sites-packages/pynput/__init__.py" ]]; do
	if [[ -e "/usr/local/Cellar/python@3.8/3.8.4/bin/pip3" ]]; then
		"/usr/local/Cellar/python@3.8/3.8.4/bin/pip3" install --user -r "$1/requirements-master.txt"
		if [[ $? == "0" ]]; then
			break
		fi
	fi
	sleep 3
done
exit 0