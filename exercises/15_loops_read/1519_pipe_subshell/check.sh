# checker spec for 1519 (see lib/engine.sh)
SEEDS=4
setup() {
  local i
  { echo "# $(words 3)"
    for i in $(seq "$(randr 3 8)"); do
      case $(rand 5) in 0) echo "# $(words 2)" ;; 1) echo ;; esac
      echo "P$(randr 100 999) $(word) $(randr 5 500)"
    done; } > pedidos.txt
}
extra_check() { must_use while read; }
