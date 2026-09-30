# checker spec for 1423 (see lib/engine.sh)
SEEDS=3
setup() {
  local i
  mkdir "full dir" "hidden only" "empty dir" locked nox
  for ((i = 0; i < $(randr 1 6); i++)); do touch "full dir/$(word)$i"; done
  [[ $(rand 2) == 1 ]] && touch "full dir/.dot"
  mkdir "full dir/sub"
  touch "hidden only/.x$(rand 9)"
  chmod 000 locked; chmod 600 nox
  echo f > file.txt
  ln -s "full dir" link
  ln -s nothere broken
}
ARGS=('"full dir" "hidden only" "empty dir" locked nox file.txt nope link broken' '.')
