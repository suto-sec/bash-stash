# checker spec for 0326 (see lib/engine.sh)
SCRIPT_NAME=dedup.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p d/sub vacio
  local i n c=() t
  for i in 1 2 3; do c+=("$(randtext "$(randr 1 4)")"); done
  n=$(randr 6 9)
  for ((i = 1; i <= n; i++)); do
    t=${c[$(rand 3)]}
    (( $(rand 4) == 0 )) && t="$t$(word)"
    printf '%s\n' "$t" > "d/$(pick "$(word)$i" "$(word) $i" "f$i.txt")"
    (( $(rand 5) == 0 )) && chmod 600 "d/f$i.txt" 2>/dev/null
  done
  printf '%s\n' "${c[0]}" > "d/aa first"
  ln "d/aa first" "d/ab hard"
  ln -s "aa first" "d/ac sym"
  printf '%s\n' "${c[0]}" > d/sub/copy
  touch d/e1 d/e2
  touch fich
}
ARGS=('d' '"$W/d"' 'vacio' '' 'd vacio' 'fich' 'noexiste')
extra_check() {
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  true
}
