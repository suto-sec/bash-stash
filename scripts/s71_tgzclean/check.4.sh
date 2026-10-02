# checker spec for s71 step 4 (see lib/engine.sh)
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
SORT_OUTPUT=1
ARGS=('data.tgz' '-n data.tgz' '-n data.tgz 1' '-n light.tgz' '-n data.tgz 100' '-n' '-n nothing.tgz' '-n fake.tgz' '-n data.tgz abc' 'light.tgz 1')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  local a; a=$(eval "set -- $CASE"; [[ $1 == -n ]] && shift; echo "$1|$2")
  [[ $REF_CODE == [234] ]] && mentions "${a%|*}"
  [[ $REF_CODE == 5 ]] && mentions "${a#*|}"
}
