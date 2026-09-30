#!/bin/bash
# check_users.sh file - validate name:uid:shell:home records

if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") file" >&2
  exit 2
fi
file=$1
if [ ! -f "$file" ] || [ ! -r "$file" ]; then
  echo "Error: '$file' is not a readable regular file" >&2
  exit 3
fi
if ! grep -qv -e '^$' -e '^#' "$file"; then
  echo "Error: '$file' has no records" >&2
  exit 4
fi

num=0 v=0 i=0
while IFS= read -r line; do
  num=$((num + 1))
  [ -z "$line" ] && continue
  [[ $line == \#* ]] && continue
  colons=${line//[^:]/}
  IFS=: read -r name uid shell home <<< "$line"
  reason=
  if [ ${#colons} -ne 3 ]; then
    reason="wrong number of fields"
  elif [[ ! $name =~ ^[a-z_][a-z0-9_-]{0,15}$ ]]; then
    reason="bad name"
  elif [[ ! $uid =~ ^[1-9][0-9]*$ ]] || [ "$uid" -lt 1000 ] || [ "$uid" -gt 60000 ]; then
    reason="bad uid"
  elif [ "$home" != "/home/$name" ]; then
    reason="bad home"
  fi
  # the shell rule goes before the home rule
  if [[ -z $reason || $reason == "bad home" ]]; then
    case $shell in
      /bin/bash | /bin/sh | /usr/bin/zsh | /usr/sbin/nologin) ;;
      *) reason="bad shell" ;;
    esac
  fi
  if [ -z "$reason" ]; then
    echo "line $num: OK ($name)"
    v=$((v + 1))
  else
    echo "line $num: $reason"
    i=$((i + 1))
  fi
done < "$file"
echo "Valid: $v, invalid: $i"
[ $i -eq 0 ] || exit 1

