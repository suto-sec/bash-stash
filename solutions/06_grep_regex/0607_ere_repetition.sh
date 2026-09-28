#!/bin/bash
grep -E '^[A-Z]{3}-[0-9]{2,4}$' codigos.txt
echo ---
grep -E 'x+y' codigos.txt
echo ---
grep -E '^colou?r$' codigos.txt

