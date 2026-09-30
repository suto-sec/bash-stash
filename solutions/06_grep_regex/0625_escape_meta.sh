#!/bin/bash
grep -E '\$[0-9]+\.[0-9]{2}([^0-9]|$)' precios.txt
echo ---
grep -F 'f(x)' precios.txt
echo ---
grep '\[ok\]' precios.txt

