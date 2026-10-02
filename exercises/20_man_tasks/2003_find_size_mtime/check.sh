# checker spec for 2003 (see lib/engine.sh)
SEEDS=4
setup() {
  mkdir -p logs/viejos
  local f
  for f in $(words 6); do bigfile "logs/$f.log" "$(pick 500 800 5000 9000)"; touch -d "$(pick 2 3 20 40) days ago" "logs/$f.log"; done
  local g=$(word) h=$(word)
  bigfile "logs/viejos/$g.log" 6000; touch -d "45 days ago" "logs/viejos/$g.log"
  bigfile "logs/viejos/$h.log" 700; touch -d "60 days ago" "logs/viejos/$h.log"
}
extra_check() { must_use find; }
