# checker spec for s67 step 5 (see lib/engine.sh)
SCRIPT_NAME=report.sh
setup() {
  mkdir -p proj/src/deep proj/docs "my proj" empty reports
  bigfile proj/a.txt 100; bigfile proj/b.txt 250; bigfile proj/src/main.c 1000; bigfile proj/src/deep/util.c 40; bigfile proj/docs/guide.md 600
  bigfile proj/Makefile 30; bigfile "proj/two words.txt" 5; bigfile "my proj/x.sh" 10; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *report.sh* ]]; }
pre_rep() { mkdir -p "$H/reports"; }
ARGS=('proj' '-o out.txt proj' '-o nodir/r.txt proj' '' '-o' '-o out.txt' 'proj empty' 'nothing' 'notadir.txt' '-o nodir/r.txt nothing' '-o out.txt notadir.txt')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "${@: -1}")"
  [[ $REF_CODE == 5 ]] && mentions "nodir/r.txt"
}
