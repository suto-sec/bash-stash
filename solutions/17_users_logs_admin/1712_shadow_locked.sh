#!/bin/bash
cat /etc/shadow > /dev/null 2>&1; echo $?
sudo grep -E '^[^:]+:!\$' /etc/shadow | cut -d: -f1 | sort
sudo grep -E '^[^:]+:\$' /etc/shadow | cut -d: -f1 | sort

