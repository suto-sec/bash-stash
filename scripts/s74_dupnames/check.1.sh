# checker spec for s74 step 1 (see lib/engine.sh)
SCRIPT_NAME=dupnames.sh
setup() {
  mkdir -p tree/a tree/b/c tree/d "my tree/x" "my tree/y" empty single
  touch tree/readme.md tree/a/readme.md tree/b/readme.md tree/a/main.c tree/b/c/main.c tree/d/main.c tree/a/only_a tree/b/c/only_c tree/a/"two words.txt" tree/d/"two words.txt" tree/a/Readme.md
  touch "my tree/x/log" "my tree/y/log" "my tree/x/solo"
  mkdir -p tree/a/data tree/b/data; touch single/one single/two
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *dupnames.sh* ]]; }
ARGS=('tree' '"my tree"' 'single' 'empty')
COMPARE="stdout exit"
