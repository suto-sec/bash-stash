# checker spec for s58 step 1 (see lib/engine.sh)
SCRIPT_NAME=linkfarm.sh
setup() {
  mkdir -p data empty links; echo a > data/a.txt; echo b > "data/two words.txt"; echo c > data/c.conf; mkdir data/sub; echo x > notadir.txt
  echo "keep" > links/a.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *linkfarm.sh* ]]; }
capture() { find . -type l -printf '%p -> %l\n' | sort; }
SORT_OUTPUT=1
ARGS=('data empty' 'empty empty')
COMPARE="stdout exit files"
