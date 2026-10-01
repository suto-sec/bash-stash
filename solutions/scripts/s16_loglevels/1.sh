#!/bin/bash
echo "ERROR: $(grep -c ' ERROR ' "$1")"
