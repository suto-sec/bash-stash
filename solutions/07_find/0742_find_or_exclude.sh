#!/bin/bash
find cache -type f \( -name '*.tmp' -o -name '*.cache' \) ! -path '*/keep/*' | sort

