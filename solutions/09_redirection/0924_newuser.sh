#!/bin/bash
# newuser.sh OUTFILE
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") OUTFILE" >&2
  exit 1
fi
OUT=$1
if [ -e "$OUT" ]; then
  echo "Error: '$OUT' already exists" >&2
  exit 2
fi

printf 'Login: ' >&2
IFS= read -r LOGIN || { echo "Error: missing answers" >&2; exit 5; }
printf 'Full name: ' >&2
IFS= read -r NAME || { echo "Error: missing answers" >&2; exit 5; }
printf 'Shell: ' >&2
IFS= read -r SH || { echo "Error: missing answers" >&2; exit 5; }

if [[ ! $LOGIN =~ ^[a-z][a-z0-9]{1,7}$ ]] || [ -z "$NAME" ]; then
  echo "Error: invalid login or empty name" >&2
  exit 3
fi
if ! grep -qxF -- "$SH" /etc/shells; then
  echo "Error: '$SH' is not a valid shell" >&2
  exit 4
fi

cat > "$OUT" << EOF
login=$LOGIN
name=$NAME
shell=$SH
home=/home/$LOGIN
EOF
echo "User $LOGIN saved to $OUT"

