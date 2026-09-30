#!/bin/bash
(exit 5) &
echo "launch: $?"
P=$!
wait "$P"
echo "wait: $?"
(sleep 0.1; exit 0) &
echo "launch: $?"
P=$!
wait "$P"
echo "wait: $?"

