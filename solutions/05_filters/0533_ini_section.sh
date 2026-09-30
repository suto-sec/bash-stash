#!/bin/bash
F=$1 S=$2
grep -qx "\[$S\]" "$F" || exit 1
sed -n "/^\[$S\]\$/,/^\[/p" "$F" | sed '1d; /^\[/d; /^[#;]/d; /^[[:space:]]*$/d'

