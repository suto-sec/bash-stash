# checker spec for s81 step 4 (see lib/engine.sh)
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
ARGS=('small.txt' 'text.txt 3' '-m 3 small.txt' '-m 4 text.txt' '-m 3 text.txt 4' '-m 1 small.txt' '-m 9 small.txt' '-m 2 empty.txt' '-m' '-m 3' '-m abc small.txt' '-m 0 small.txt' '-m 3 nothing.txt' '-m 3 adir' '-m 3 small.txt abc' '' 'small.txt 0')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  if [[ $REF_CODE == [234] ]]; then
    local a; a=$(eval "set -- $CASE"; m=; if [[ $1 == -m ]]; then m=$2; shift 2; fi; echo "$1|$2|$m")
    local f=${a%%|*} r=${a#*|}; local n=${r%%|*} m=${r#*|}
    if [[ $REF_CODE == [23] ]]; then mentions "$f"; elif [[ -n $m && ! $m =~ ^[0-9]+$ || $m == 0 ]]; then mentions "$m"; else mentions "$n"; fi
  fi
}
