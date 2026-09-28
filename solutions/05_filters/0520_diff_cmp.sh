#!/bin/bash
diff v1.txt v2.txt
echo ---
cmp v1.txt v2.txt
echo ---
diff -q v1.txt copia.txt && echo equal
exit 0

