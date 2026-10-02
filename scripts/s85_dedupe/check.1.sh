# checker spec for s85 step 1 (see lib/engine.sh)
SCRIPT_NAME=dedupe.sh
setup() {
  mkdir -p pics/old pics/new "my pics" empty single
  echo "sunset" > pics/a.txt; echo "sunset" > pics/b.txt; echo "sunset" > pics/old/a_copy.txt; echo "sunset" > "pics/new/two words.txt"
  echo "forest" > pics/c.txt; echo "forest" > pics/new/c2.txt
  echo "unique one" > pics/d.txt; echo "unique two" > pics/old/e.txt
  : > pics/empty1; : > pics/old/empty2
  printf 'x' > pics/new/tiny; printf 'x' > pics/tiny2
  echo "hello" > "my pics/h1"; echo "hello" > "my pics/h2"; echo "bye" > "my pics/b1"
  echo "one" > single/o; echo "two" > single/t
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *dedupe.sh* ]]; }
ARGS=('pics' '"my pics"' 'single' 'empty')
COMPARE="stdout exit"
