#!/bin/bash
grep -Eo '\b(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\b' versiones.txt |
  sort -t. -k1,1n -k2,2n -k3,3n -u

