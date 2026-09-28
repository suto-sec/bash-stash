#!/bin/bash
mkdir "$1" 2>/dev/null && echo "created $1" || echo "could not create $1"
cd "$1" 2>/dev/null && echo inside || { echo "cannot enter"; exit 1; }
pwd

