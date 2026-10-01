# checker spec for s27 step 2 (see lib/engine.sh)
SCRIPT_NAME=diskuse.sh
setup() {
  mkdir -p base/alpha base/bravo base/charlie "base/two words" base/delta empty; local d
  bigfile base/alpha/a.dat 3000; bigfile base/bravo/b.dat 100; bigfile base/charlie/c.dat 8000; bigfile "base/two words/w.dat" 5000
  bigfile base/delta/d.dat 100; echo loose > base/loose.txt; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *diskuse.sh* ]]; }
ARGS=('base' 'empty')
COMPARE="stdout exit"
