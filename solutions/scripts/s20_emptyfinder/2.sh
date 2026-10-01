#!/bin/bash
find "$1" -type f -empty | sed 's/^/file: /'
find "$1" -type d -empty | sed 's/^/dir: /'
