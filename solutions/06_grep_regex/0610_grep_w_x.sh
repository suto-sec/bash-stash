#!/bin/bash
grep -w log palabras.txt
echo ---
grep -x log palabras.txt
echo ---
grep -c log palabras.txt

