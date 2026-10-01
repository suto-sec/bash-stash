# checker spec for s34 step 1 (see lib/engine.sh)
SCRIPT_NAME=cmpfiles.sh
setup() {
  printf 'one\ntwo\nthree\n' > a.txt; printf 'one\ntwo\nthree\n' > same.txt; printf 'one\nTWO\nthree\n' > diff.txt
  printf 'one\n' > short.txt; : > empty.txt; echo x > "my file.txt"; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *cmpfiles.sh* ]]; }
ARGS=('a.txt same.txt' 'a.txt diff.txt' 'a.txt short.txt' 'empty.txt empty.txt' '"my file.txt" a.txt')
COMPARE="stdout exit"
