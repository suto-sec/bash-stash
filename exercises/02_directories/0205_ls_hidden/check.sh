# checker spec for 0205 (see lib/engine.sh)
setup() { mkdir cfg; local i; for i in $(seq "$(randr 2 5)"); do touch "cfg/$(word)$i" "cfg/.$(word)rc$i"; done; }
extra_check() { must_use ls; }
