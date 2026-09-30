#!/bin/bash
# mkconf.sh [-f] NAME PORT
usage() { echo "Usage: $(basename "$0") [-f] NAME PORT" >&2; exit 1; }
FORCE=0
if [ "$1" = "-f" ]; then
  FORCE=1
  shift
fi
[ $# -eq 2 ] || usage
NAME=$1
PORT=$2
if [[ ! $NAME =~ ^[a-z][a-z0-9_-]*$ ]]; then
  echo "Error: invalid name '$NAME'" >&2
  exit 2
fi
if [[ ! $PORT =~ ^[1-9][0-9]{0,4}$ ]] || [ "$PORT" -gt 65535 ]; then
  echo "Error: invalid port '$PORT'" >&2
  exit 3
fi
DIR=$HOME/.config/apps
F=$DIR/$NAME.conf
if [ -e "$F" ] && [ $FORCE -eq 0 ]; then
  echo "Error: $F already exists (use -f)" >&2
  exit 4
fi
if [ -e "$F" ]; then MSG=Overwritten; else MSG=Created; fi
mkdir -p "$DIR"
cat > "$F" << EOF
# $NAME configuration (generated)
[main]
name = $NAME
port = $PORT
user = $USER
log = $HOME/logs/$NAME.log
[paths]
data = \${DATA_DIR}/$NAME
EOF
echo "$MSG $F"
echo "$(ls "$DIR"/*.conf | wc -l) configurations in $DIR"

