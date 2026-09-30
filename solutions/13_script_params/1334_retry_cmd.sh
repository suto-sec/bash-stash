#!/bin/bash
# retry_cmd.sh N CMD [ARGS...]
if [ $# -lt 2 ] || ! [[ $1 =~ ^[0-9]+$ ]] || [ "$1" -eq 0 ]; then
  echo "usage: $(basename "$0") N CMD [ARGS...]" >&2
  exit 1
fi
N=$1
shift
K=0
LAST=1
ok=
while [ "$K" -lt "$N" ]; do
  K=$((K + 1))
  "$@" > /dev/null 2>&1
  LAST=$?
  echo "intento $K: exit $LAST"
  if [ "$LAST" -eq 0 ]; then
    ok=$K
    break
  fi
done
if [ -n "$ok" ]; then
  echo "resultado: exito en el intento $ok"
  exit 0
else
  echo "resultado: fallo tras $N intentos"
  exit "$LAST"
fi

