#!/bin/bash
grep 'Failed password' /var/log/auth.log | tr -s ' ' | cut -d' ' -f1,2 | uniq -c | while read -r n m d; do echo "$m $d: $n"; done

