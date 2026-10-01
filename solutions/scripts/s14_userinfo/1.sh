#!/bin/bash
grep "^$2:" "$1" | cut -d: -f6
