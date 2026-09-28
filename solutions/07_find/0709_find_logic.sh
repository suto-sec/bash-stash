#!/bin/bash
find docs \( -name 'a*' -o -name 'b*' \) ! -name '*~*' | sort

