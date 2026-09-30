#!/bin/bash
gzip -k entradas/*.csv
for f in entradas/*.csv.gz; do
  echo "$f: $(zcat "$f" | wc -c) bytes"
done

