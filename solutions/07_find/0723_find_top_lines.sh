#!/bin/bash
find src -type f \( -name '*.c' -o -name '*.h' \) -exec wc -l {} \; | sort -k1,1nr -k2 | head -n 3

