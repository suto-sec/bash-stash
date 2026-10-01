#!/bin/bash
if cmp -s "$1" "$2"; then echo same; else echo different; fi
