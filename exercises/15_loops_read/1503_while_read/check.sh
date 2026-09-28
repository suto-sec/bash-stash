# checker spec for 1503 (see lib/engine.sh)
setup() { { local i; for i in $(seq "$(randr 2 6)"); do echo "$(pick '' '   ' '	')$(words 3) $(pick '' '\n' '\\t')"; done; printf '%s' "$(words 2)"; } > entrada.txt; }
extra_check() { must_use while read; }
