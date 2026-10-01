# checker spec for s40 step 3 (see lib/engine.sh)
SCRIPT_NAME=backup2.sh
setup() {
  mkdir -p src/sub/deep dst newparent empty
  echo a > src/a.txt; echo b > src/sub/b.txt; echo c > src/sub/deep/c.txt; echo w > "src/two words.txt"
  touch -d "@1700100000" src/a.txt; touch -d "@1700300000" src/sub/b.txt; touch -d "@1700500000" src/sub/deep/c.txt; touch -d "@1700200000" "src/two words.txt"
  echo l > src/locked.txt; chmod 000 src/locked.txt; touch -d "@1700600000" src/locked.txt
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *backup2.sh* ]]; }
pre_marker() { mkdir -p dstm; echo old > dstm/a.txt; echo "marker" > dstm/.last; touch -d "@1700250000" dstm/.last; }
SORT_OUTPUT=1
ARGS=('src dst' 'src newdst' 'src "new parent/dst"' '' 'src' 'src dst extra' 'nothing dst' 'notadir.txt dst' 'src notadir.txt' 'src dstm $(pre_marker)')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  if [[ $REF_CODE == [23] ]]; then local a; a=$(eval "set -- $CASE"; [[ -d $W/$1 ]] && echo "$2" || echo "$1"); mentions "$a"; fi
}
