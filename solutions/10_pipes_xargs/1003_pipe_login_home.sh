#!/bin/bash
cut -d: -f1,6 passwd | sort | tr : '\t'

