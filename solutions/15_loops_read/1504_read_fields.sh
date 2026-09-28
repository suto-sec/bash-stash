#!/bin/bash
while IFS=: read -r user x uid gid gecos home shell; do
  [ "$uid" -ge 1000 ] && echo "$user ($uid) -> $shell"
done < passwd

