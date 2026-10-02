# checker spec for 2001 (see lib/engine.sh)
SEEDS=4
setup() {
  mkdir -p app/bin app/lib app/sub/deep
  local f
  for f in $(words 3); do mkf "app/$f.sh" '#!/bin/bash'; chmod "$(pick 755 750 700 711)" "app/$f.sh"; done
  for f in $(words 2); do mkf "app/bin/$f.bin" x; chmod "$(pick 755 710 701)" "app/bin/$f.bin"; done
  mkf "app/sub/$(word).sh" x; chmod 644 app/sub/*.sh
  mkf "app/sub/deep/$(word).py" x; chmod 755 app/sub/deep/*.py
  mkf "app/lib/$(word).bin" x; chmod 640 app/lib/*.bin
  mkdir "app/lib/$(word).sh"
}
extra_check() { must_use find; }
