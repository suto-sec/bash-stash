#!/bin/bash
find "$1" -type f -printf '%s %p\n' | sort -nr | head -n 1
