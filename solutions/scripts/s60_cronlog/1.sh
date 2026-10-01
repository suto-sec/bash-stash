#!/bin/bash
echo "Jobs: $(grep -c ' CMD (' "$1")"
