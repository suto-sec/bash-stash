#!/bin/bash
find docs -type f -name '*.txt' -exec cat {} + | wc -l

