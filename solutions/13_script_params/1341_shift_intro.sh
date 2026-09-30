#!/bin/bash
echo "Primero: $1"
shift
if [ $# -eq 0 ]; then echo none; else echo "Ahora: $1"; fi
