#!/bin/bash
echo $(echo "$1" | base64) > /tmp/"$2"