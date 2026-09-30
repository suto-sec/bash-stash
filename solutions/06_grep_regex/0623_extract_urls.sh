#!/bin/bash
grep -oE 'https?://[A-Za-z0-9.-]+' pagina.html | cut -d/ -f3 | sort -u
echo ---
grep -o 'http://' pagina.html | wc -l

