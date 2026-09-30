# checker spec for 1615 (see lib/engine.sh)
SEEDS=1
ARGS=('ana' 'hola' 'a' '' 'radar noesto racecar x' '"a x a"' '"ana a"')
extra_check() { must_use return; }
