#!/bin/bash
find media -type f -print0 | xargs -0 stat -c '%s %n' | sort -k1,1nr -k2,2 | head -n 3

