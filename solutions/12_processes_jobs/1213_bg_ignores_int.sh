#!/bin/bash
sleep 300 &
P=$!
kill -INT "$P"
sleep 0.3
if kill -0 "$P" 2>/dev/null; then echo alive; else echo dead; fi
kill -QUIT "$P"
sleep 0.3
if kill -0 "$P" 2>/dev/null; then echo alive; else echo dead; fi
kill "$P"
sleep 0.3
if kill -0 "$P" 2>/dev/null; then echo alive; else echo dead; fi
wait "$P" 2>/dev/null
echo $?

