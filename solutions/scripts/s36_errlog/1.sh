#!/bin/bash
echo "$(grep -c ' ERROR ' "$1") errors"
