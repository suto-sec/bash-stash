#!/bin/bash
for f in "$@"; do
  chmod u+x -- "$f"
  echo "ok $f"
done
