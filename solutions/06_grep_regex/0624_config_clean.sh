#!/bin/bash
grep -vE '^[[:space:]]*(#|$)' app.conf
echo ---
grep -E '^[^#=[:space:]]+=[[:space:]]*$' app.conf | cut -d= -f1 | sort

