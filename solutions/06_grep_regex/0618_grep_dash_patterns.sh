#!/bin/bash
grep -e -rf cmds.txt
echo ---
grep -e -n -e --dry-run cmds.txt
echo ---
grep -vc -- - cmds.txt

