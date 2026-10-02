#!/bin/bash
find arbol -type f -printf '%s %p\n' | sort -k2

