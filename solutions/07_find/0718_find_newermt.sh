#!/bin/bash
find fotos -type f -newermt '2024-01-01 00:00' ! -newermt '2025-01-01 00:00' | sort
echo ---
find fotos -type f -exec stat -c '%Y %n' {} + | sort -k1,1n | tail -n 1 | cut -d' ' -f2-

