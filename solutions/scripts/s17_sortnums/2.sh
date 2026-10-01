#!/bin/bash
sorted=$(sort -n "$1")
echo "$sorted"
echo "min: $(echo "$sorted" | head -n 1)"
echo "max: $(echo "$sorted" | tail -n 1)"
