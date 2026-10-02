#!/bin/bash
find app -type f -perm /111 \( -name '*.sh' -o -name '*.bin' \) | sort

