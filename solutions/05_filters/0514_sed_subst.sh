#!/bin/bash
sed 's/a/AAA/g' passwd
echo ---
sed 's/sys/SYSTEM/' passwd
echo ---
sed 's#/bin/bash#/bin/zsh#' passwd

