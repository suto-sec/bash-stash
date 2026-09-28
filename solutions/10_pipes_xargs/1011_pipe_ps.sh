#!/bin/bash
ps -e -o user= | sort | uniq -c

