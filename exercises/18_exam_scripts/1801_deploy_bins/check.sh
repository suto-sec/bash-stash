# checker spec for 1801 (see lib/engine.sh)
SCRIPT_NAME=deploy_bins.sh
SEEDS=2
COMPARE="stdout exit files"
setup() {
  local i f n=0
  mkdir -p "src/sub/deep" "mi dir" "src/x.sh"
  for d in src src/sub src/sub/deep "mi dir" .; do
    for i in 1 2 3; do
      n=$((n + 1)); f="$d/$(word)$n$(pick .sh .bin .sh .txt .shx '') "; f=${f% }
      [[ $(rand 4) == 0 ]] && f="$d/my $(word)$n$(pick .sh .bin)"
      echo "echo $n" > "$f"; chmod "$(pick 755 644 700 604 601 610 744 754)" "$f"
    done
  done
  echo "echo locked" > "src/locked$n.sh"; chmod 100 "src/locked$n.sh"
  touch notadir.txt
  if [[ $(rand 2) == 1 ]]; then mkdir -p "$H/deploy/bin"; echo old > "$H/deploy/bin/old.sh"; fi
}
ARGS=('' 'src' '"mi dir"' 'src/sub' 'noexiste' 'notadir.txt' 'src "mi dir"' '"$W/src"')
extra_check() {
  if [[ $REF_CODE == [123] ]]; then
    [[ -n $ERR ]] || fail "expected an error message on stderr"
    [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
    [[ $REF_CODE == 1 ]] && { [[ $ERR == *deploy_bins.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script"; }
  fi
}
