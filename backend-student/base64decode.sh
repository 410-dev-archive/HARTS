#!/bin/bash
echo $(echo "$1" | base64 --decode) > /tmp/"$2"