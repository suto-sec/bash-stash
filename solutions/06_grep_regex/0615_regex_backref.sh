#!/bin/bash
grep '\(.\)\1\1' /usr/share/dict/words
echo ---
grep '^\([a-z]\)\([a-z]\)[a-z]\2\1$' /usr/share/dict/words

