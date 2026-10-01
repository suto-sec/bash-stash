# checker spec for s12 step 2 (see lib/engine.sh)
SCRIPT_NAME=findext.sh
setup() {
  mkdir -p proj/src/deep proj/docs "my dir" empty; local i
  for i in 1 2 3; do echo "$i" > "proj/$(word)$i.txt"; echo "$i" > "proj/src/$(word)$i.c"; done
  echo a > proj/docs/readme.txt; echo b > proj/src/deep/note.txt; echo c > "my dir/two words.txt"; echo d > proj/x.TXT
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *findext.sh* ]]; }
SORT_OUTPUT=1
ARGS=('txt' 'txt proj' 'c proj/src' 'txt "my dir"' 'txt empty' '"txt" "$W/proj"')
COMPARE="stdout exit"
