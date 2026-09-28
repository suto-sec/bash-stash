#!/bin/bash
grep -q kernel texto.txt; echo $?
grep -q zzzzz texto.txt; echo $?
grep -q kernel noexiste.txt 2>/dev/null; echo $?
if grep -q shell texto.txt; then echo found; else echo "not found"; fi

