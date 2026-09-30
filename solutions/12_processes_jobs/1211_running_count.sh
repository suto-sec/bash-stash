#!/bin/bash
sleep 101 &
sleep 102 &
sleep 103 &
jobs -r | wc -l
kill %1 %3
wait %1 %3 2>/dev/null
jobs -r | wc -l
kill %2
wait %2 2>/dev/null
jobs -r | wc -l

