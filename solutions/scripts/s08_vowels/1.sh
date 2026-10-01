#!/bin/bash
echo "$1" | tr -cd 'aeiouAEIOU' | wc -c
