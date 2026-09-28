#!/bin/bash
[ -z "$1" ] && echo "first empty" || echo "first not empty"
[ -n "$2" ] && echo "second not empty" || echo "second empty"
[ "$1" = "$2" ] && echo equal || echo different
if [[ $1 == "$2" ]]; then echo same
elif [[ $1 < $2 ]]; then echo "$1"
else echo "$2"
fi

