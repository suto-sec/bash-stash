# checker spec for s85 step 4 (see lib/engine.sh)
SCRIPT_NAME=dedupe.sh
setup() {
  mkdir -p pics/old pics/new "my pics" empty single
  echo "sunset" > pics/a.txt; echo "sunset" > pics/b.txt; echo "sunset" > pics/old/a_copy.txt; echo "sunset" > "pics/new/two words.txt"
  echo "forest" > pics/c.txt; echo "forest" > pics/new/c2.txt
  echo "unique one" > pics/d.txt; echo "unique two" > pics/old/e.txt
  : > pics/empty1; : > pics/old/empty2
  printf 'x' > pics/new/tiny; printf 'x' > pics/tiny2
  echo "hello" > "my pics/h1"; echo "hello" > "my pics/h2"; echo "bye" > "my pics/b1"
  echo "one" > single/o; echo "two" > single/t
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *dedupe.sh* ]]; }
ARGS=('pics' '-d pics' '-d "my pics"' '"my pics"' '-d single' 'single' 'empty' '-d empty' '' '-d' 'nothing' '-d notadir.txt' 'pics single')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; [[ $1 == -d ]] && shift; echo "$1")"
}
