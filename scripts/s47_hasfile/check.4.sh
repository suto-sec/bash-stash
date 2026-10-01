# checker spec for s47 step 4 (see lib/engine.sh)
SCRIPT_NAME=hasfile.sh
setup() {
  mkdir -p site/css site/img; echo a > site/index.html; echo b > site/about.html; echo c > "site/two words.txt"; echo d > site/css/main.css
  mkdir empty; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *hasfile.sh* ]]; }
ARGS=('site index.html css' 'site index.html missing.txt a' 'empty a b' '' 'nothing a' 'site')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
