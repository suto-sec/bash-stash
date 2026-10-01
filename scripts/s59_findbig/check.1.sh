# checker spec for s59 step 1 (see lib/engine.sh)
SCRIPT_NAME=findbig.sh
setup() {
  mkdir -p proj/src/deep "my proj" empty
  bigfile proj/a.dat 1200; bigfile proj/src/b.dat 4500; bigfile proj/src/deep/c.dat 300; bigfile proj/d.dat 8000
  bigfile "my proj/two words.dat" 2500; bigfile proj/src/e.dat 4500; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *findbig.sh* ]]; }
ARGS=('proj' '"my proj"' 'empty' 'proj/src/deep')
COMPARE="stdout exit"
