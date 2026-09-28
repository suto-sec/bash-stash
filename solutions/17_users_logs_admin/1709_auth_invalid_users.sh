#!/bin/bash
grep 'Invalid user' /var/log/auth.log | sed 's/.*Invalid user \([^ ]*\) from.*/\1/' | sort | uniq -c | sort -k1,1nr -k2,2

