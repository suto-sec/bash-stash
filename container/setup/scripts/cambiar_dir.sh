#!/bin/bash
# Changes to the directory given as argument (default: /tmp) and prints it.
cd "${1:-/tmp}"
echo "Ahora estoy en: $(pwd)"
