#!/bin/bash
grep '^sys' passwd
echo ---
grep 'bash$' passwd
echo ---
grep -c '^$' passwd

