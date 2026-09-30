#!/bin/bash
LOG=/var/log/auth.log
grep -oE 'Invalid user [^ ]+ from' "$LOG" | cut -d' ' -f3 | sort | uniq -c | sort -k1,1nr -k2,2 | head -n 5 | sed 's/^ *//'
echo ---
grep -oE 'Invalid user [^ ]+ from' "$LOG" | cut -d' ' -f3 | sort -u | wc -l
echo ---
grep -oE 'Invalid user [^ ]+ from [0-9.]+' "$LOG" | cut -d' ' -f3,5 | sort -u | cut -d' ' -f2 |
  sort | uniq -c | sort -k1,1nr -k2,2 | head -n 1 | sed 's/^ *//'

