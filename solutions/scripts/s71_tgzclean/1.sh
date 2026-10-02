#!/bin/bash
tgz=$(realpath "$1")
tmp=$(mktemp -d)
tar -xzf "$tgz" -C "$tmp"
n=$(find "$tmp" -type f -size +8192c | wc -l)
find "$tmp" -type f -size +8192c -delete
tar -czf "$tgz" -C "$tmp" .
rm -rf "$tmp"
echo "Removed $n files"
