#!/bin/bash
tar xzf "$1" -C "$2"
echo "Extracted $(tar tzf "$1" | wc -l) entries"
