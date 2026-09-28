#!/bin/bash
who | wc -l
who | cut -d' ' -f1 | sort -u
who | grep '(' | grep -v '(:0' | sed -E 's/^([^ ]+).*\((.*)\)$/\1 from \2/' | sort

