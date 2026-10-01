#!/bin/bash
echo "$2: $(grep -c -- "$1" "$2")"
