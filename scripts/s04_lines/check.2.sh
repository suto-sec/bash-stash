# checker spec for s04 step 2 (see lib/engine.sh)
SCRIPT_NAME=lines.sh
setup() {
  local i
  for ((i = 0; i < $(randr 2 9); i++)); do echo "alpha $(word) $i"; done > a.txt
  for ((i = 0; i < $(randr 3 12); i++)); do echo "beta $(words 3) $i"; done > b.txt
  : > empty.txt
  for ((i = 0; i < $(randr 1 5); i++)); do echo "gamma $(word) $i"; done > "my file.txt"
  printf 'locked\n' > locked.txt; chmod 000 locked.txt
  mkdir adir
}
ARGS=('a.txt' 'b.txt' 'empty.txt' '"my file.txt"' '' 'a.txt b.txt' 'nothing.txt' 'adir' 'locked.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 1 ]] && { [[ $ERR == *lines.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the message should show the correct usage"; }
}
