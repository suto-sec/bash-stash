#!/bin/bash
grep -rl TODO src | sort
echo ---
grep -c TODO src/*.c
echo ---
grep -rh TODO src | sort

