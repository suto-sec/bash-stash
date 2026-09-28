#!/bin/bash
if [ "$1" -nt "$2" ]; then echo "$1 is newer"
elif [ "$1" -ot "$2" ]; then echo "$2 is newer"
else echo "same age"
fi

