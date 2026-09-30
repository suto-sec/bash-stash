# checker spec for 0428 (see lib/engine.sh)
SEEDS=1
COMPARE="stdout exit files"
setup() { randtext 3 > dato.txt; tar -cf paquete.tar dato.txt; rm dato.txt; }
