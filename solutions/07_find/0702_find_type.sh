#!/bin/bash
find proyecto -type d | sort
echo ---
find proyecto -type f | sort
echo ---
find proyecto -type f -name '*.c' | wc -l

