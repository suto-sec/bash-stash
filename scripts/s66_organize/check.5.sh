# checker spec for s66 step 5 (see lib/engine.sh)
SCRIPT_NAME=organize.sh
setup() {
  mkdir -p org org2/txt org3 empty
  for n in a.txt b.txt c.md run.sh data "two words.txt" archive.tar.gz; do echo "$n" > "org/$n"; done; echo h > org/.hidden; mkdir org/subdir; echo i > org/subdir/inner.txt
  for n in a.txt z.txt c.md; do echo "new $n" > "org2/$n"; done; echo "old a" > org2/txt/a.txt; echo "old a1" > org2/txt/a.txt.1
  echo p > org3/p.txt; echo q > org3/q.md; chmod 555 org3
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *organize.sh* ]]; }
ARGS=('org' 'org2' 'empty' 'org3' '' 'org empty' 'nothing' 'notadir.txt')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
