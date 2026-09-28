#!/bin/bash
while IFS=: read -r login x uid gid gecos home shell; do
  if [ "$uid" -ge 1000 ] && [ "$uid" -lt 60000 ]; then
    echo "$login | $uid | ${gecos%%,*} | $home | $shell"
  fi
done < /etc/passwd

