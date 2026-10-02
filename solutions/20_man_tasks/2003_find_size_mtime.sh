#!/bin/bash
find logs -type f -size +2k -mtime +7 | sort

