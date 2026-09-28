#!/bin/bash
P=$(cat path.txt)
dirname "$P"
basename "$P"
basename "$P" .tar.gz
basename "$(dirname "$P")"

