# checker spec for 0913 (see lib/engine.sh)
COMPARE="stdout stderr exit files"
setup() {
  local i n
  for i in $(seq "$(randr 4 7)"); do
    n="$(pick '' 'my ')$(word)$i.txt"
    echo "$n"
    [[ $(rand 2) == 1 ]] && echo "old $(word)" > "$n"
  done > lista.txt
  echo "old $(words 2)" > forzar.txt
}
extra_check() {
  ans_code | grep -qE 'noclobber|set -C' || fail "turn on noclobber (set -o noclobber)"
  ans_code | grep -q '>|' || fail "use >| to force the overwrite"
}
