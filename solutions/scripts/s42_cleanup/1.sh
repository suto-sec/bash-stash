#!/bin/bash
find "$1" -type f \( -name "*.tmp" -o -name "*~" \) -mtime +7
