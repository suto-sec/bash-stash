# checker spec for 1541 (see lib/engine.sh)
SEEDS=5
setup() {
  local i n falpos
  n=$(randr 4 9)
  falpos=0
  [[ $(rand 3) != 0 ]] && falpos=$(randr 1 "$n")
  for i in $(seq "$n"); do
    if [ "$i" -eq "$falpos" ]; then
      echo "$(word)$i fallo"
    else
      echo "$(word)$i $(pick pendiente hecho)"
    fi
  done > tareas.txt
}
extra_check() { must_use break continue; }
