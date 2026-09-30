#!/bin/bash
# leaderboard.sh SCORES [N]: best score and games of every player, ranked

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") SCORES [N]" >&2
  exit 1
fi
F=$1 N=${2:-3}
if [ ! -f "$F" ] || [ ! -r "$F" ]; then
  echo "Error: cannot read '$F'" >&2
  exit 2
fi
if ! [[ $N =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: '$N' is not a positive integer" >&2
  exit 3
fi

DATA=$(tail -n +2 "$F")
PLAYERS=$(echo "$DATA" | cut -d';' -f1 | sort -u)

# one line per player: best;games;player
while IFS= read -r p; do
  rows=$(echo "$DATA" | grep -- "^$p;")
  best=$(echo "$rows" | cut -d';' -f3 | sort -nr | head -n 1)
  games=$(echo "$rows" | wc -l)
  echo "$best;$games;$p"
done <<< "$PLAYERS" |
  sort -t';' -k1,1nr -k2,2nr -k3,3 | head -n "$N" |
  while IFS=';' read -r best games p; do echo "$p: best $best, games $games"; done |
  nl -w 1 -s '. '

echo "Players: $(echo "$PLAYERS" | wc -l), games: $(echo "$DATA" | wc -l)"
