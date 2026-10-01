# checker spec for s65 step 1 (see lib/engine.sh)
SCRIPT_NAME=quota.sh
setup() {
  mkdir -p proj/sub empty; bigfile proj/a.dat 1000; bigfile proj/sub/b.dat 2500; bigfile "proj/two words.dat" 500; bigfile proj/sub/c.dat 0
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *quota.sh* ]]; }
ARGS=('proj' 'proj/sub' 'empty')
COMPARE="stdout exit"
