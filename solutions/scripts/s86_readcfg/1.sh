#!/bin/bash
grep -v '^#' "$1" | grep "^$2=" | tail -n 1 | cut -d= -f2-
