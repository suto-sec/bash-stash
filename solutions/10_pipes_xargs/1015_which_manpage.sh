#!/bin/bash
comm -23 <(ls /bin | grep '^z' | sort) <(ls /usr/share/man/man1 | sed 's/\.1\.gz$//' | sort)

