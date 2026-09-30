#!/bin/bash
tac eventos.txt | paste -d, - - -
echo ---
paste -s -d';' eventos.txt

