# checker spec for 0212 (see lib/engine.sh)
setup() { mkdir -p Datos/{Inversiones,Nominas/2025,Stocks}; local d; for d in Datos/*/; do touch "$d$(word).txt"; done; touch "Datos/Nominas/2025/$(word).pdf"; }
