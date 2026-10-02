# checker spec for 2002 (see lib/engine.sh)
SEEDS=4
setup() {
  mkdir -p publico/sub
  local f
  for f in $(words 6); do mkf "publico/$f" x; chmod "$(pick 644 640 600 664 604 444 400)" "publico/$f"; done
  for f in $(words 2); do mkf "publico/sub/$f" x; chmod "$(pick 644 640 604 700)" "publico/sub/$f"; done
  mkf publico/seguro x; chmod 640 publico/seguro
}
extra_check() { must_use find; }
