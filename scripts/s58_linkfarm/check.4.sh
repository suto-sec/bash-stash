# checker spec for s58 step 4 (see lib/engine.sh)
SCRIPT_NAME=linkfarm.sh
setup() {
  mkdir -p data empty links; echo a > data/a.txt; echo b > "data/two words.txt"; echo c > data/c.conf; mkdir data/sub; echo x > notadir.txt
  echo "keep" > links/a.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *linkfarm.sh* ]]; }
capture() { find . -type l -printf '%p -> %l\n' | sort; }
SORT_OUTPUT=1
ARGS=('data empty' 'data links' 'data newlinks' 'empty links' '' 'nothing empty' 'data notadir.txt')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  if [[ $REF_CODE == [23] ]]; then local a; a=$(eval "set -- $CASE"; [[ -d $W/$1 ]] && echo "$2" || echo "$1"); mentions "$a"; fi
}
