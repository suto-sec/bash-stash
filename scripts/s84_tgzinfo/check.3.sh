# checker spec for s84 step 3 (see lib/engine.sh)
SCRIPT_NAME=tgzinfo.sh
setup() {
  mkdir -p src/docs src/img "src/my files" lone
  bigfile src/readme.md 100; bigfile src/docs/guide.md 300; bigfile src/docs/notes.txt 50; bigfile src/img/logo.png 4000; bigfile src/img/photo.jpg 12000
  bigfile "src/my files/a b.txt" 20; bigfile src/Makefile 40; bigfile src/docs/index.md 10
  tar -czf data.tgz -C src .
  bigfile lone/only.txt 5; tar -czf small.tgz -C lone .
  mkdir -p emptydir/sub; tar -czf dirs.tgz -C emptydir .
  echo "not an archive" > fake.tgz; mkdir dir.tgz
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *tgzinfo.sh* ]]; }
ARGS=('data.tgz' 'small.tgz' 'dirs.tgz' '' 'nothing.tgz' 'fake.tgz')
COMPARE="stdout exit errmsg"
extra_check() { [[ $REF_CODE == [234] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"; }
