#!/bin/bash
name=$(basename "$1")
out=$HOME/archives/$name.tgz
tar czf "$out" -C "$(dirname "$1")" "$name"
echo "Created $out"
