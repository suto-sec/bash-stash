#!/bin/bash
find var/log -type f -iname '*.log' -size +5k -mtime +14 | sort

