# checker spec for 0726 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  local i p j n
  mkdir -p src
  for i in $(seq "$(randr 3 6)"); do
    p=src
    n=$(randr 1 3)
    for ((j = 0; j < n; j++)); do p="$p/$(pick "$(word)" "$(word) $(word)" data)"; done
    mkdir -p "$p"
    [[ $(rand 2) == 1 ]] && touch "$p/$(word).txt"
  done
  mkdir -p src/.cache/tmp
  touch src/readme.md
  ln -s .cache src/cachelink
}
