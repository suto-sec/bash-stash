# checker spec for s81 step 2 (see lib/engine.sh)
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
ARGS=('small.txt' 'small.txt 2' 'text.txt' 'text.txt 1' 'text.txt 100' 'empty.txt 3' '"two words.txt" 9')
COMPARE="stdout exit"
