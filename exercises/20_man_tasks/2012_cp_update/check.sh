# checker spec for 2012 (see lib/engine.sh)
SEEDS=3
COMPARE="files exit"
setup() {
  mkdir origen destino
  local f i=0
  for f in $(words 6); do
    mkf "origen/$f" "origen $f"
    touch -d "2024-03-1$(( i % 5 )) 10:00" "origen/$f"
    case $(( i % 3 )) in
      0) mkf "destino/$f" "destino viejo $f"; touch -d "2024-03-0$(( i % 5 + 1 )) 10:00" "destino/$f" ;;
      1) mkf "destino/$f" "destino nuevo $f"; touch -d "2024-04-0$(( i % 5 + 1 )) 10:00" "destino/$f" ;;
    esac
    i=$(( i + 1 ))
  done
  mkf "destino/solo_aqui_$(word)" "stays"
}
extra_check() { must_use cp; }
