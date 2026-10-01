# checker spec for s10 step 2 (see lib/engine.sh)
SCRIPT_NAME=backup1.sh
setup() {
  echo "a" > a.txt; echo "bb" > b.txt; echo "two words" > "my file.txt"; mkdir docs; echo n > docs/n.txt
  echo "locked" > locked.txt; chmod 000 locked.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *backup1.sh* ]]; }
pre_b() { mkdir -p "$H/backup"; }
ARGS=('a.txt $(pre_b)' 'a.txt' '"my file.txt"' 'b.txt $(pre_b)')
COMPARE="stdout exit files"
