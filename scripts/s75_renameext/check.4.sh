# checker spec for s75 step 4 (see lib/engine.sh)
SCRIPT_NAME=renameext.sh
setup() {
  mkdir -p docs "my docs" empty docs/dir.txt
  echo 1 > docs/a.txt; echo 2 > docs/a.md; echo 3 > docs/b.txt; echo 4 > docs/c.md; echo 5 > "docs/two words.txt"
  echo 6 > docs/.hid.txt; echo 7 > docs/x.txt.bak; echo 8 > docs/notes.txt; echo 9 > docs/notes.markdown; echo 10 > docs/d.txt
  echo 11 > docs/d.md; echo 12 > "my docs/r.txt"; echo 13 > "my docs/s.txt"
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *renameext.sh* ]]; }
SORT_OUTPUT=1
ARGS=('docs txt md' '"my docs" txt md' 'empty txt md' 'docs md txt' 'docs bak old' '' 'nothing txt md' 'notadir.txt txt md')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
