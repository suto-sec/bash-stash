#!/bin/bash
sed -E 's#([0-9]{2})/([0-9]{2})/([0-9]{4})#\3-\2-\1#g' notas.txt
echo ---
sed -E 's/^([^,]+), ([^:]+): (.*)$/\2 \1 (\3)/' contactos.txt

