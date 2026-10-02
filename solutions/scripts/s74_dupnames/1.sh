#!/bin/bash
find "$1" -type f -printf '%f\n' | sort | uniq -d
