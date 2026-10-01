#!/bin/bash
cp -- "$1" "$1.1"
: > "$1"
echo "Rotated $1"
