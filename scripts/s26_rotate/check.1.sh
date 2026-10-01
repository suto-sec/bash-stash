# checker spec for s26 step 1 (see lib/engine.sh)
SCRIPT_NAME=rotate.sh
setup() {
  echo "log a" > a.log
  echo "log b" > b.log; echo "b1" > b.log.1
  echo "log c" > c.log; echo "c1" > c.log.1; echo "c2" > c.log.2; echo "c3" > c.log.3; echo "c4" > c.log.4
  echo "log d" > "my d.log"; echo "d1" > "my d.log.1"; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *rotate.sh* ]]; }
ARGS=('a.log' 'b.log' '"my d.log"')
COMPARE="stdout exit files"
