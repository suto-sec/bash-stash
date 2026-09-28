#!/bin/bash
grep 'Failed password' /var/log/auth.log | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | sort -k1,1nr -k2,2 | head -n 5

