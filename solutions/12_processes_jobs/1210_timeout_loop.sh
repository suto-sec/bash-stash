#!/bin/bash
./worker.sh &
for ((i = 0; i < 50; i++)); do
  [ -e done.flag ] && break
  sleep 0.1
done
wait
echo "worker finished"
cat done.flag
