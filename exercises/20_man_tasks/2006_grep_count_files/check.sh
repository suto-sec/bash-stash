# checker spec for 2006 (see lib/engine.sh)
SEEDS=3
setup() {
  mkdir logs
  local f i
  for f in $(words 4); do
    for i in $(seq "$(randr 3 8)"); do if (( $(rand 3) == 0 )); then echo "$(word) ERROR $(word)"; else echo "$(word) $(pick INFO WARN) $(word)"; fi; done > "logs/$f.log"
  done
  echo "$(word) INFO $(word)" > "logs/$(word).log"
}
extra_check() { must_use grep; must_not_use wc; }
