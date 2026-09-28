# checker spec for 0909 (see lib/engine.sh)
COMPARE="stdout stderr exit"
setup() { randtext "$(randr 1 9)" > existe.txt; }
ARGS=('existe.txt' 'noexiste.txt')
