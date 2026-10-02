#!/bin/bash
cut -d: -f7 "$1" | sort | uniq -c | sort -k1,1nr -k2,2 | while read -r n sh; do echo "$sh: $n"; done
exit 0
