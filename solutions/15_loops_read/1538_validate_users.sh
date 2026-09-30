#!/bin/bash
# valida_usuarios.sh FILE
[ $# -eq 1 ] || { echo "usage: $(basename "$0") FILE" >&2; exit 1; }
[ -f "$1" ] && [ -r "$1" ] || { echo "error: cannot read '$1'" >&2; exit 2; }

n=0; V=0; I=0
users=' '; uids=' '                    # space-separated lists of what OK lines used
while IFS= read -r line; do
  n=$((n + 1))
  [[ -z $line || $line == \#* ]] && continue
  IFS=: read -r u id sh <<< "$line"
  err=
  if [[ ! $line =~ ^[^:]*:[^:]*:[^:]*$ ]]; then err="wrong field count"
  elif [[ ! $u =~ ^[a-z][a-z0-9]*$ ]]; then err="bad user name"
  elif [[ $users == *" $u "* ]]; then err="duplicate user $u"
  elif [[ ! $id =~ ^[0-9]+$ ]] || (( 10#$id < 1000 || 10#$id > 60000 )); then err="bad uid"
  elif [[ $uids == *" $id "* ]]; then err="duplicate uid $id"
  else
    case $sh in /bin/bash|/bin/sh|/usr/sbin/nologin) ;; *) err="bad shell" ;; esac
  fi
  if [ -n "$err" ]; then
    echo "line $n: ERROR $err"; I=$((I + 1))
  else
    echo "line $n: OK $u"; V=$((V + 1)); users+="$u "; uids+="$id "
  fi
done < "$1"
echo "valid $V, invalid $I"
[ $I -eq 0 ] || exit 4

