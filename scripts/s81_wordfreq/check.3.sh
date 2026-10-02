# checker spec for s81 step 3 (see lib/engine.sh)
SCRIPT_NAME=wordfreq.sh
setup() {
  mkdir -p adir
  local i
  for ((i = 0; i < 40; i++)); do echo "$(word) $(word) $(pick The the THE A a an) $(word) it's $(pick 'end.' 'end,' 'End!')"; done > text.txt
  printf 'one two two\nThree three THREE, three!\nfour four-five\n' > small.txt
  : > empty.txt
  printf 'hello\n' > "two words.txt"
  echo x > file.bin
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *wordfreq.sh* ]]; }
ARGS=('small.txt' 'text.txt 3' 'empty.txt' '' 'small.txt 2 3' 'nothing.txt' 'adir' 'small.txt 0' 'small.txt abc' 'small.txt -2' 'small.txt 2.5' 'nothing.txt abc')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 4 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
}
