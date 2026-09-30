# checker spec for 0619 (see lib/engine.sh)
setup() {
  local i w
  for i in $(seq 22); do
    w=$(word)
    [[ $(rand 3) != 0 ]] && w=${w^}
    [[ $(rand 3) == 0 ]] && w="$w$(word)"
    [[ $(rand 4) != 0 ]] && w="$w$(rand 100)"
    [[ $(rand 4) != 0 ]] && w="$w$(pick '!' . '#' _ @ % -)"
    [[ $(rand 8) == 0 ]] && w=${w^^}
    echo "$w"
  done > candidatas.txt
}
