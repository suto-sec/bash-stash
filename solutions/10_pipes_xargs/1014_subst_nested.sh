#!/bin/bash
echo "The file $(basename "$(cat ruta.txt)") is in $(dirname "$(cat ruta.txt)") which contains $(ls "$(dirname "$(cat ruta.txt)")" | wc -l) entries"

