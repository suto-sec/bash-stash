# checker spec for s71 step 2 (see lib/engine.sh)
SCRIPT_NAME=tgzclean.sh
setup() {
  mkdir -p src/docs src/img "src/my files"
  bigfile src/small.txt 100; bigfile src/docs/notes.txt 2000; bigfile src/docs/manual.pdf 9000; bigfile src/img/photo.jpg 20000
  bigfile "src/my files/big one.dat" 8193; bigfile "src/my files/edge.dat" 8192; bigfile src/tiny 1
  tar -czf data.tgz -C src .
  rm -rf src; mkdir -p src; bigfile src/a 10; bigfile src/b 500; tar -czf light.tgz -C src .; rm -rf src
  echo "this is not an archive" > fake.tgz; mkdir dir.tgz
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *tgzclean.sh* ]]; }
capture() { for f in *.tgz; do [[ -f $f ]] && { echo "== $f"; tar -tzvf "$f" 2>&1 | awk '{print $3, $6}' | sort -k2; }; done; }
ARGS=('data.tgz' 'light.tgz' '' 'data.tgz light.tgz' 'nothing.tgz' 'dir.tgz' 'fake.tgz')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [234] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
