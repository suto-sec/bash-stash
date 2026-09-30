#!/bin/bash
tee today.log | tee -a history.log | grep '^ERROR '
echo "saved $(wc -l < today.log) lines"

