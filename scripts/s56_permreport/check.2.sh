# checker spec for s56 step 2 (see lib/engine.sh)
SCRIPT_NAME=permreport.sh
setup() {
  mkdir -p site empty; local n m
  for n in index.html style.css app.sh notes.txt run.sh "two words.txt"; do echo "$n" > "site/$n"; chmod "$(pick 644 666 755 600 640 777 664 662)" "site/$n"; done
  mkdir site/sub; chmod 777 site/sub; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *permreport.sh* ]]; }
SORT_OUTPUT=1
ARGS=('site' 'empty' '' 'site empty' 'nothing' 'notadir.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
