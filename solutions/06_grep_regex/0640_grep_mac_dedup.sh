#!/bin/bash
grep -Eo '\b([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}\b' dispositivos.txt | tr 'A-F' 'a-f' | sort -u

