#!/bin/bash
if [ -L "$1" ]; then echo "$1 is a symbolic link"
elif [ -d "$1" ]; then echo "$1 is a directory"
elif [ -f "$1" ]; then echo "$1 is a regular file"
elif [ -e "$1" ]; then echo "$1 is something else"
else echo "$1 does not exist"
fi

