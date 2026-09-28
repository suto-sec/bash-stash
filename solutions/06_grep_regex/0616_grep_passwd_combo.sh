#!/bin/bash
grep ':/bin/bash$' /etc/passwd | cut -d: -f1 | sort
echo ---
grep '^r' /etc/passwd | cut -d: -f1 | sort
echo ---
grep -v ':$' /etc/group | cut -d: -f1 | sort
