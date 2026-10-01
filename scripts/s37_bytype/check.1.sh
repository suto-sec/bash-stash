# checker spec for s37 step 1 (see lib/engine.sh)
SCRIPT_NAME=bytype.sh
setup() {
  mkdir -p mixed empty onlydirs/sub; local n
  for n in a.txt b.md c.txt run.sh prog.c tool.py x.png y.jpg z.jpg data.csv archive.tgz "two words.txt" LICENSE; do echo "$n" > "mixed/$n"; done
  echo h > mixed/.hidden.txt; mkdir mixed/sub.txt; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *bytype.sh* ]]; }
ARGS=('mixed' 'empty' 'onlydirs')
COMPARE="stdout exit"
