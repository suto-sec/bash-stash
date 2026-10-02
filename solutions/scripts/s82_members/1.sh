#!/bin/bash
grep "^$1:" "$2" | cut -d: -f4 | tr ',' '\n' | grep .
exit 0
