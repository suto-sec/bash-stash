#!/bin/bash
list=$(tar -tzf "$1")
total=$(echo "$list" | grep -c .)
dirs=$(echo "$list" | grep -c '/$')
echo "Entries: $total"
echo "Directories: $dirs"
echo "Files: $((total - dirs))"
