#!/bin/bash
grep 'COMMAND=' /var/log/auth.log | sed 's/.*COMMAND=//' | sort | uniq -c | sort -k1,1nr -k2

