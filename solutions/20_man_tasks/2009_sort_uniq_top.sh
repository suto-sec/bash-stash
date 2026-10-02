#!/bin/bash
sort ips.txt | uniq -c | sort -rn | head -n 3

