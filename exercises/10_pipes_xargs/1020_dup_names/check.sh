# checker spec for 1020 (see lib/engine.sh)
setup() {
  mkdir -p tree/a/b "tree/c d" tree/e
  local i names=("$(word)" "$(word).txt" "$(word) copy" "$(word).txt" "$(word)")
  for i in $(seq "$(randr 6 12)"); do
    touch "tree/$(pick . a a/b 'c d' e)/$(pick "${names[@]}")"
  done
  touch "tree/e/unique$(word).txt"
  mkdir -p "tree/a/b/${names[0]}x" "tree/e/${names[1]}x"
  touch "tree/a/${names[1]}x"
}
