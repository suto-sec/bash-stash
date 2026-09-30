# checker spec for 0741 (see lib/engine.sh)
setup() {
  mkdir -p sistema/sub
  local i f
  local perms=(755 644 600 700 777 4755 4644 4100 750 770 666 4711 700 640)
  i=0
  for perm in "${perms[@]}"; do
    i=$((i+1))
    f="sistema/$(pick . sub)/$(word)$i"
    touch "$f"
    chmod "$perm" "$f"
  done
}
