# checker spec for 0614 (see lib/engine.sh)
setup() { local i; for i in $(seq 25); do echo "$(pick 19 20 21 18)$(randr 10 99)-$(pick 01 02 09 10 11 12 13 00 1)-$(pick 01 09 10 19 20 29 30 31 32 00 5)$(pick '' '' '' ' ' x)"; done > fechas.txt; }
