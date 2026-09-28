#!/bin/bash
wc -l < /etc/passwd
echo ---
cut -d: -f1 /etc/passwd | sort
echo ---
cut -d: -f1 /etc/passwd | grep '^r'
echo ---
who | cut -d' ' -f1 | sort -u

