#!/bin/bash
echo "Accepted: $(grep -c 'Accepted password' "$1")"
echo "Failed: $(grep -c 'Failed password' "$1")"
