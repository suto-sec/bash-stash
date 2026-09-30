#!/bin/bash
# equipo.sh GROUP FILE - make GROUP's members exactly the users in FILE (run as root)
[ $# -eq 2 ] || { echo "Usage: $(basename "$0") GROUP FILE" >&2; exit 1; }
G=$1
F=$2
[ -r "$F" ] || { echo "Error: cannot read $F" >&2; exit 2; }

if ! getent group "$G" > /dev/null; then
  groupadd "$G" && echo "Group $G created"
fi
members() { getent group "$G" | cut -d: -f4 | tr , '\n' | grep -v '^$'; }

A=0; R=0; RC=0
while read -r u; do
  [ -z "$u" ] && continue
  if ! id "$u" > /dev/null 2>&1; then
    echo "unknown user $u" >&2; RC=3; continue
  fi
  members | grep -qx "$u" && continue
  gpasswd -a "$u" "$G" > /dev/null && echo "+ $u" && A=$((A + 1))
done < "$F"

for u in $(members); do
  if ! grep -qx "$u" "$F"; then
    gpasswd -d "$u" "$G" > /dev/null && echo "- $u" && R=$((R + 1))
  fi
done

LIST=$(members | sort | tr '\n' , | sed 's/,$//')
echo "$G: added $A, removed $R, members: ${LIST:-(none)}"
exit $RC

