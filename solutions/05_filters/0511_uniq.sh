#!/bin/bash
sort accesos.txt | uniq
echo ---
sort accesos.txt | uniq -c
echo ---
sort accesos.txt | uniq -d

