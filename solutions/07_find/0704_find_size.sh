#!/bin/bash
find datos -type f -size +2M | sort
echo ---
find datos -type f -size -10k | sort
echo ---
find datos -type f -empty | sort

