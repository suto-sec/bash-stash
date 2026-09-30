#!/bin/bash
grep -rL --include='*.txt' DONE proyecto | sort
echo ---
grep -rlw --include='*.md' DONE proyecto | sort
echo ---
grep -ril done proyecto | wc -l

