#!/bin/bash
find logs -type f -name '*.log' -size +2k -print0 | xargs -0 -r gzip
find logs -name '*.gz' | sort

