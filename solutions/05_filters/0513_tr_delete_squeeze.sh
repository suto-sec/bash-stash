#!/bin/bash
tr -d '0-9' | tr -s ' '
tr -cd 'a-zA-Z\n' < ruido.txt

