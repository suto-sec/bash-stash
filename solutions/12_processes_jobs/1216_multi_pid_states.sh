#!/bin/bash
sleep 300 & P1=$!
sleep 300 & P2=$!
sleep 300 & P3=$!
sleep 300 & P4=$!
kill -STOP "$P2" "$P4"
sleep 0.2
S=$(ps -o stat= -p "$P1,$P2,$P3,$P4")
echo "running: $(echo "$S" | grep -c '^S')"
echo "stopped: $(echo "$S" | grep -c '^T')"
kill -CONT "$P2" "$P4"
sleep 0.2
S=$(ps -o stat= -p "$P1,$P2,$P3,$P4")
echo "running: $(echo "$S" | grep -c '^S')"
echo "stopped: $(echo "$S" | grep -c '^T')"
kill -9 "$P1" "$P2" "$P3" "$P4"
wait 2>/dev/null

