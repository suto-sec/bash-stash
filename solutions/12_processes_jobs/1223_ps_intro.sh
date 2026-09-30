#!/bin/bash
sleep 300 &
P=$!
if ps -p "$P" > /dev/null; then echo found; else echo "not found"; fi
kill "$P" 2>/dev/null

