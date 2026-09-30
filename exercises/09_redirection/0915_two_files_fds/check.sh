# checker spec for 0915 (see lib/engine.sh)
setup() {
  local i n
  n=$(randr 3 8)
  for i in $(seq "$n"); do pick "$(word)" "${WORDS[$(rand 20)]^} $(word)" "Ana Maria" "Luis"; done > nombres.txt
  for i in $(seq "$n"); do rand 11; done > notas.txt
}
extra_check() { must_not_use paste; }
