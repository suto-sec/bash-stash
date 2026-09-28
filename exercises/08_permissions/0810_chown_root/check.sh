# checker spec for 0810 (see lib/engine.sh)
COMPARE="stdout exit files owner"
RUN_AS_ROOT=1
setup() { touch informe.txt datos.csv publico; mkdir -p proyecto/src; touch proyecto/a proyecto/src/b; }
