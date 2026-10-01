# checker spec for s04 step 1 (see lib/engine.sh)
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
ARGS=('a.txt' 'b.txt' 'empty.txt' '"my file.txt"')
COMPARE="stdout exit"
