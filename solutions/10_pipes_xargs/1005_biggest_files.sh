#!/bin/bash
ls -S datos | grep -v -x -e a -e b -e c | head -n 3
echo ---
du -s datos/*/ | sort -nr | head -n 2

