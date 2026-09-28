#!/bin/bash
find logs -type f -mtime +7 | sort
echo ---
find logs -type f -mtime -3 | sort
echo ---
find logs -type f -newer logs/referencia | sort

