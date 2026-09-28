# checker spec for 1111 (see lib/engine.sh)
setup() { local i; for i in $(seq "$(randr 3 7)"); do pick apple banana cherry grape lemon mango melon orange peach pear plum kiwi; done > frutas.txt; }
