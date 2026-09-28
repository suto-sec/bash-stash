#!/bin/bash
sleep 101 &
sleep 102 &
sleep 103 &
jobs
kill %2
wait %2 2>/dev/null
jobs
kill %1 %3
wait 2>/dev/null

