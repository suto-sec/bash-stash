# checker spec for 1112 (see lib/engine.sh)
setup() { randr 1 5000 > n.txt; printf '%x\n' "$(randr 1 65535)" > hex.txt; echo "$(randr 0 1)$(randr 0 1)$(randr 0 1)$(randr 0 1)1$(randr 0 1)$(randr 0 1)" > bin.txt; }
