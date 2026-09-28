#!/bin/bash
find src -type f -perm /111 \( -name '*.sh' -o -name '*.bin' \) | sort

