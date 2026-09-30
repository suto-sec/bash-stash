#!/bin/bash
tree --noreport -P '*.c' --prune proyecto
echo ---
tree --noreport -I 'build|*.o' proyecto
echo ---
tree --noreport -a -f -i proyecto/docs

