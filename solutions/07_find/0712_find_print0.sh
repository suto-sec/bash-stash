#!/bin/bash
find docs -type f -name '*.txt' -print0 | xargs -0 cat | wc -l

