#!/bin/bash
grep zzz noexiste.txt 2>/dev/null | wc -l
echo $?
grep zzz noexiste.txt 2>/dev/null | wc -l
echo "${PIPESTATUS[@]}"
set -o pipefail
grep zzz noexiste.txt 2>/dev/null | wc -l
echo $?

