# checker spec for s81 step 1 (see lib/engine.sh)
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
ARGS=('small.txt' 'text.txt' 'empty.txt' '"two words.txt"')
COMPARE="stdout exit"
