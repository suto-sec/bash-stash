#!/bin/bash
find bin -type f -perm 755 | sort
echo ---
find bin -type f -perm /111 | sort
echo ---
find bin -type f -perm -220 | sort
echo ---
find bin -type f ! -perm /111 | sort

