#!/bin/bash
find sistema -type f -perm /022 | sort
echo ---
find sistema -type f -perm -700 ! -perm /077 | sort
echo ---
find sistema -type f -perm -4100 | sort

