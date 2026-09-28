#!/bin/bash
diff <(sort lista1.txt) <(sort lista2.txt)
echo ---
comm -12 <(sort lista1.txt) <(sort lista2.txt)
exit 0

