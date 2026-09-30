#!/bin/bash
find etc -type f -name '*.conf' -exec grep -liw debug {} + | sort
echo ---
find etc -type f -name '*.conf' -exec grep -Liw debug {} + | sort

