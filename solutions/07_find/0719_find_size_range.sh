#!/bin/bash
find data -type f -size +999c -size -5001c -exec stat -c '%s %n' {} + | sort -k1,1n -k2
echo ---
find data -type f -size +0c -size -1025c | sort

