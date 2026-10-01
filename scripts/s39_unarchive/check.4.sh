# checker spec for s39 step 4 (see lib/engine.sh)
SCRIPT_NAME=unarchive.sh
setup() {
  mkdir -p src/docs/sub; echo a > src/docs/a.txt; echo b > "src/docs/two words.txt"; echo c > src/docs/sub/c.txt
  tar czf docs.tgz -C src docs; tar czf docs2.tar.gz -C src docs; rm -rf src
  echo "just text" > notes.txt; echo "not really gzip" > fake.tgz
  mkdir emptyout fullout; echo x > fullout/old.txt; echo x > notanarchive.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *unarchive.sh* ]]; }
ARGS=('docs.tgz emptyout' 'docs.tgz fullout' 'docs.tgz newdir' 'docs2.tar.gz' 'docs.tgz' '' 'nothing.tgz' 'notanarchive.txt')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 4 ]] && mentions "$(eval "set -- $CASE"; echo "${2:-extracted}")"
}
