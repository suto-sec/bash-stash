# checker spec for s52 step 1 (see lib/engine.sh)
SCRIPT_NAME=dirsize.sh
setup() {
  mkdir -p alpha/sub beta empty "my dir"; echo a > alpha/a.txt; echo b > alpha/b.txt; echo h > alpha/.hidden; echo c > beta/c.txt
  echo x > "my dir/one"; echo y > "my dir/two"; echo z > "my dir/three"; echo f > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *dirsize.sh* ]]; }
ARGS=('alpha' 'alpha beta empty' '"my dir" beta' 'empty')
COMPARE="stdout exit"
