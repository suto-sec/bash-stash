#!/bin/bash
ls -A d
ls -l d | tail -n +2 | cut -d' ' -f1

