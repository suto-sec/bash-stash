# checker spec for s21 step 4 (see lib/engine.sh)
SCRIPT_NAME=execlist.sh
setup() {
  mkdir -p proj/src/deep "my proj" empty; local i n=0
  for d in proj proj/src proj/src/deep "my proj"; do
    for i in 1 2 3; do n=$((n + 1)); f="$d/$(word)$n$(pick .sh .sh .txt .bin)"; echo "echo $n" > "$f"; chmod "$(pick 755 644 700 744 600 611)" "$f"; done
  done
  echo "echo l" > proj/locked.sh; chmod 100 proj/locked.sh
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *execlist.sh* ]]; }
pre_bin() { mkdir -p "$H/bin"; }
ARGS=('proj' 'proj $(pre_bin)' '"my proj" $(pre_bin)' 'empty' 'nothing' 'notadir.txt' 'proj extra')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
