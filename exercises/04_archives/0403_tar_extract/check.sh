# checker spec for 0403 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p Datos/Stocks Textos; randtext 3 > "Datos/Stocks/$(word).txt"; randtext 2 > "Textos/$(word)"; tar -czf archivo.tgz Datos Textos; rm -r Datos Textos; }
extra_check() { must_use -C; }
