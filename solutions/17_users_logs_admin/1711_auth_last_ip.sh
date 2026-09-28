#!/bin/bash
IP=$(grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' /var/log/auth.log | tail -n 1)
echo "$IP"
grep -cF "$IP" /var/log/auth.log

