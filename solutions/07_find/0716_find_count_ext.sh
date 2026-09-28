#!/bin/bash
find repo -type f -name '*.*' | sed 's/.*\.//' | sort | uniq -c | sort -k1,1nr -k2,2
