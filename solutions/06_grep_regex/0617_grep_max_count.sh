#!/bin/bash
grep -m 3 ERROR app.log
echo ---
grep -n -m 1 WARN app.log | cut -d: -f1
echo ---
head -n 10 app.log | grep -c ERROR

