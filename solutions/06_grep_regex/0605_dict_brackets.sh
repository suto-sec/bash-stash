#!/bin/bash
grep 'b[ae]g' /usr/share/dict/words
echo ---
grep 'b[^ae]g' /usr/share/dict/words
echo ---
grep -c '^[A-Z].*ing$' /usr/share/dict/words

