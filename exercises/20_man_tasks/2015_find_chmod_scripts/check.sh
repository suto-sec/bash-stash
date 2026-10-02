# checker spec for 2015 (see lib/engine.sh)
SEEDS=3
COMPARE="files exit"
setup() {
  mkdir -p herramientas/sub
  local f
  for f in $(words 3); do mkf "herramientas/$f.sh" x; chmod "$(pick 644 600 640 664 444)" "herramientas/$f.sh"; done
  for f in $(words 2); do mkf "herramientas/sub/$f.sh" x; chmod "$(pick 644 600 640)" "herramientas/sub/$f.sh"; done
  mkf "herramientas/$(word).txt" x; chmod 644 herramientas/*.txt
  mkf "herramientas/sub/$(word).py" x; chmod 600 herramientas/sub/*.py
}
extra_check() { must_use find chmod; }
