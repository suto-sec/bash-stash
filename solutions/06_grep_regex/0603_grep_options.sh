#!/bin/bash
grep -in error log.txt
echo ---
grep -vic error log.txt
echo ---
grep warn log.txt | grep -v disk

