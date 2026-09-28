#!/bin/bash
groups jgarcia
id -u rosa
id -G luke
if id "$1" > /dev/null 2>&1; then echo exists; else echo "no such user"; fi

