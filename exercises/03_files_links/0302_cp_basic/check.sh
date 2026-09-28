# checker spec for 0302 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p Datos/Stocks Datos/Inversiones; printf '2017 - Primer trimestre\n---------------------\nEnero %s\nFebrero %s\nMarzo %s\n' $(randr 1000 5000) $(randr 1000 5000) $(randr 1000 5000) > Datos/Stocks/Trimestre.17.1.txt; }
