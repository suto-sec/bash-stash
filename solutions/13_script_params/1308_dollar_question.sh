#!/bin/bash
ls / > /dev/null 2>&1; echo $?
ls /noexiste > /dev/null 2>&1; echo $?
grep root /etc/passwd > /dev/null 2>&1; echo $?
grep zzzz /etc/passwd > /dev/null 2>&1; echo $?
test 3 -gt 5; echo $?
true; echo $?
false; echo $?
mkdir existe 2>/dev/null; A=$?
mkdir existe 2>/dev/null; B=$?
echo "first=$A second=$B"

