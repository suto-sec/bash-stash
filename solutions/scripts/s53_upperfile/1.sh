#!/bin/bash
tr a-z A-Z < "$1" > "$1.upper"
echo "Created $1.upper"
