# checker spec for s26 step 3 (see lib/engine.sh)
SCRIPT_NAME=rotate.sh
setup() {
  echo "log a" > a.log
  echo "log b" > b.log; echo "b1" > b.log.1
  echo "log c" > c.log; echo "c1" > c.log.1; echo "c2" > c.log.2; echo "c3" > c.log.3; echo "c4" > c.log.4
  echo "log d" > "my d.log"; echo "d1" > "my d.log.1"; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *rotate.sh* ]]; }
ARGS=('a.log' 'c.log' 'c.log 2' 'c.log 1' 'c.log 10' 'b.log 5' '"my d.log" 2')
COMPARE="stdout exit files"
