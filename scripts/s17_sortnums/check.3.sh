# checker spec for s17 step 3 (see lib/engine.sh)
SCRIPT_NAME=sortnums.sh
setup() {
  local i
  for ((i = 0; i < $(randr 5 12); i++)); do echo "$(randr 1 500)"; done > nums.txt
  printf '10\n9\n100\n-5\n7\n' > mixed.txt; echo 42 > one.txt; : > empty.txt
  echo x > locked.txt; chmod 000 locked.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *sortnums.sh* ]]; }
ARGS=('nums.txt' 'one.txt' '' 'nums.txt mixed.txt' 'nothing.txt' 'adir' 'locked.txt' 'empty.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
