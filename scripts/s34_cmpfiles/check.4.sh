# checker spec for s34 step 4 (see lib/engine.sh)
SCRIPT_NAME=cmpfiles.sh
setup() {
  printf 'one\ntwo\nthree\n' > a.txt; printf 'one\ntwo\nthree\n' > same.txt; printf 'one\nTWO\nthree\n' > diff.txt
  printf 'one\n' > short.txt; : > empty.txt; echo x > "my file.txt"; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *cmpfiles.sh* ]]; }
ARGS=('a.txt same.txt' 'a.txt diff.txt' 'a.txt short.txt' 'empty.txt empty.txt' '' 'a.txt nothing.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  if [[ $REF_CODE == 2 ]]; then local a; a=$(eval "set -- $CASE"; [[ -f $W/$1 ]] && echo "$2" || echo "$1"); mentions "$a"; fi
}
