#!/bin/bash
{ read -r W1; read -r W2; } < words.txt
R=$(grep -rlZ -- "$W1" notes | xargs -0 -r grep -l -- "$W2" | sort)
[ -n "$R" ] && echo "$R"
echo "$(echo -n "$R" | grep -c '^') files contain both"

