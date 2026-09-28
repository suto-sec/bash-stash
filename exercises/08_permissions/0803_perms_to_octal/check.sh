# checker spec for 0803 (see lib/engine.sh)
setup() { mkdir varios; local i f; for i in $(seq 6); do f="varios/$(word)$i"; if [[ $(rand 3) == 0 ]]; then mkdir "$f"; else touch "$f"; fi; chmod "$(randr 0 7)$(randr 0 7)$(randr 0 7)" "$f"; done; }
