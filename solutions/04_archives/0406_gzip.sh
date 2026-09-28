#!/bin/bash
zcat logs/old.log.gz
gzip logs/*.log
gunzip logs/old.log.gz

