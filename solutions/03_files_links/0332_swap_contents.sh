#!/bin/bash
tmp=$(mktemp -p .)
mv a.txt "$tmp"
mv b.txt a.txt
mv "$tmp" b.txt

