#!/bin/bash
tar -czf proyecto.tgz proyecto
TMP=$(mktemp -d)
tar -xzf proyecto.tgz -C "$TMP"
if diff -r proyecto "$TMP/proyecto" > /dev/null; then echo "backup OK"; else echo "backup FAILED"; fi
rm -rf "$TMP"
