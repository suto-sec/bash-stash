# checker spec for s23 step 3 (see lib/engine.sh)
SCRIPT_NAME=permfix.sh
setup() {
  mkdir -p tools/sub "my tools" empty; local i n=0
  for d in tools tools/sub "my tools"; do
    for i in 1 2 3; do n=$((n + 1)); f="$d/$(word)$n.sh"; echo "echo $n" > "$f"; chmod "$(pick 755 644 700 600 775 750 666)" "$f"; done
  done
  echo x > tools/notes.txt; chmod 644 tools/notes.txt; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *permfix.sh* ]]; }
SORT_OUTPUT=1
ARGS=('tools' '"my tools"' '' 'tools empty' 'nothing' 'notadir.txt')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
