#!/bin/bash
f=$1
echo "$f: $(wc -l < "$f")"
