# checker spec for s52 step 2 (see lib/engine.sh)
SCRIPT_NAME=dirsize.sh
setup() {
  mkdir -p alpha/sub beta empty "my dir"; echo a > alpha/a.txt; echo b > alpha/b.txt; echo h > alpha/.hidden; echo c > beta/c.txt
  echo x > "my dir/one"; echo y > "my dir/two"; echo z > "my dir/three"; echo f > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *dirsize.sh* ]]; }
ARGS=('alpha' 'alpha beta empty' '' 'nothing' 'alpha nothing beta' 'notadir.txt alpha' 'nothing notadir.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && { local a; for a in $(eval "set -- $CASE"; for x in "$@"; do [[ -d $W/$x ]] || echo "$x"; done); do mentions "$a"; done; }
}
