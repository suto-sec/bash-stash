# checker spec for s29 step 3 (see lib/engine.sh)
SCRIPT_NAME=syncnew.sh
setup() {
  mkdir -p src dst "src dir" empty; local i
  for n in alpha bravo charlie delta "two words"; do echo "src $n" > "src/$n.txt"; touch -d "@1700100000" "src/$n.txt"; done
  echo "dst old" > dst/alpha.txt; touch -d "@1700000000" dst/alpha.txt        # older than the source: must be updated
  echo "dst new" > dst/bravo.txt; touch -d "@1700200000" dst/bravo.txt        # newer than the source: must stay
  echo "dst only" > dst/zulu.txt; mkdir src/sub; echo "x" > src/sub/inner.txt
  echo "locked" > src/locked.txt; chmod 000 src/locked.txt; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *syncnew.sh* ]]; }
SORT_OUTPUT=1
ARGS=('src dst' '"src dir" newdst' 'src "new dir"' '' 'src' 'src dst extra' 'nothing dst' 'notadir.txt dst' 'src notadir.txt')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  if [[ $REF_CODE == [23] ]]; then local a; a=$(eval "set -- $CASE"; [[ -d $W/$1 ]] && echo "$2" || echo "$1"); mentions "$a"; fi
}
