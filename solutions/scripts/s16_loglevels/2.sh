#!/bin/bash
for level in INFO WARN ERROR; do
  echo "$level: $(grep -c " $level " "$1")"
done
