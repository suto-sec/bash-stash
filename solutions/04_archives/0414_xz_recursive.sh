#!/bin/bash
find datos -type f -exec xz {} \;
echo "Compressed $(find datos -type f -name '*.xz' | wc -l) files."

