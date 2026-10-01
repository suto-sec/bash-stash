#!/bin/bash
sort -u "$1"
echo "Distinct: $(sort -u "$1" | wc -l)"
