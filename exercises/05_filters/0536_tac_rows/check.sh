# checker spec for 0536 (see lib/engine.sh)
setup() {
  local i n t=$(randr 0 300); n=$(randr 4 13)
  for ((i = 0; i < n; i++)); do t=$(( t + $(randr 1 40) )); printf '%02d:%02d %s %s\n' $(( t / 60 % 24 )) $(( t % 60 )) "$(word)" "$(word)"; done > eventos.txt
}
extra_check() { must_use tac; must_use paste; }
