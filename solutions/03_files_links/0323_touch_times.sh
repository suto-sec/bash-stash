#!/bin/bash
touch -d "$(cat fecha)" c.txt
touch -r a.txt b.txt
touch -r c.txt nuevo.txt
ls -t *.txt

