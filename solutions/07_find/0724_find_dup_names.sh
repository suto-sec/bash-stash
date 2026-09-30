#!/bin/bash
find music -type f | sed 's#.*/##' | sort | uniq -d
echo ---
find music -type f | sed 's#.*/##' | sort -u | wc -l

