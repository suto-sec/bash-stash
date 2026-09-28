# checker spec for 0513 (see lib/engine.sh)
input() { local i; for i in $(seq 4); do echo "$(word)$(randr 1 99)    $(word)  $(randr 1 9)$(word)   end"; done; }
setup() { local i; for i in $(seq 3); do echo "$(word)!!$(randr 1 9)#$(word)@@ $(word)."; done > ruido.txt; }
