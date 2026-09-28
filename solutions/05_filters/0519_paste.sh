#!/bin/bash
paste nombres.txt edades.txt
echo ---
paste -d, nombres.txt edades.txt
echo ---
paste -s -d+ nombres.txt

