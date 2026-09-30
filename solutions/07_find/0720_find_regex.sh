#!/bin/bash
find camera -type f -regextype posix-extended -regex '.*/IMG_[0-9]{4}\.jpe?g' | sort
echo ---
find camera -type f -regextype posix-extended -regex '.*/[^/]*[0-9]{4}-[0-9]{2}-[0-9]{2}[^/]*' | sort

