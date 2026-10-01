# checker spec for s65 step 2 (see lib/engine.sh)
SCRIPT_NAME=quota.sh
setup() {
  mkdir -p proj/sub empty; bigfile proj/a.dat 1000; bigfile proj/sub/b.dat 2500; bigfile "proj/two words.dat" 500; bigfile proj/sub/c.dat 0
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *quota.sh* ]]; }
ARGS=('proj 5000' 'proj 4000' 'proj 3999' 'proj 100' 'empty 0' 'empty 10')
COMPARE="stdout exit"
