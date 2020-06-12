#!/bin/bash
echo $(echo "$1" | base64 -d) > /tmp/"$2"