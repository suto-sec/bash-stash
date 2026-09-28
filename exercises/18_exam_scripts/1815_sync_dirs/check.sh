# checker spec for 1815 (see lib/engine.sh)
SCRIPT_NAME=sync.sh
COMPARE="stdout exit errmsg files mtime"
setup() {
  mkdir -p src/{a,b/c} dst/a; local i f
  for i in $(seq 8); do f="$(pick . a b/c)/$(word) $i.txt"; randtext 2 > "src/$f"; touch -d "2026-06-1$(randr 0 9) 10:00" "src/$f"
    case $(rand 3) in 0) mkdir -p "dst/$(dirname "$f")"; randtext 1 > "dst/$f"; touch -d "2026-06-01 10:00" "dst/$f";; 1) mkdir -p "dst/$(dirname "$f")"; randtext 1 > "dst/$f"; touch -d "2026-06-25 10:00" "dst/$f";; esac
  done
  touch dst/solo_en_destino
}
ARGS=('src dst' 'src nuevo' 'src/b "$W/dst"' 'noexiste dst' 'src' '')
