#!/bin/bash
line=$(grep "^$2:" "$1")
uid=$(echo "$line" | cut -d: -f3)
shell=$(echo "$line" | cut -d: -f7)
echo "$2: uid=$uid shell=$shell"
