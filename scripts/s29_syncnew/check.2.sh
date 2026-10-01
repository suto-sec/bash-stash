# checker spec for s29 step 2 (see lib/engine.sh)
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
ARGS=('"src dir" dst' 'src dst' 'empty dst')
COMPARE="stdout exit files"
