# checker spec for 0622 (see lib/engine.sh)
setup() {
  mkdir -p "proyecto/sub dir" proyecto/docs
  local i j f
  for i in $(seq 9); do
    f="proyecto/$(pick . 'sub dir' docs)/$(pick '' 'my ')$(word)$i.$(pick txt md txt md log)"
    for j in $(seq "$(randr 1 4)"); do echo "$(word) $(pick DONE done 'DONE.' UNDONE 'NOT DONE' '' '' Done) $(word)"; done > "$f"
  done
}
