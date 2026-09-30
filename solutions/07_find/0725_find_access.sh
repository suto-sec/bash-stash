#!/bin/bash
find share -type f ! -readable 2>/dev/null | sort
echo ---
find share -type d ! -executable 2>/dev/null | sort
echo ---
find share -type f -name '*.txt' -writable 2>/dev/null | sort

