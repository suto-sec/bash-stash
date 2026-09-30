#!/bin/bash
sleep 0.2 &
P=$!
echo launched
wait "$P"
echo done
