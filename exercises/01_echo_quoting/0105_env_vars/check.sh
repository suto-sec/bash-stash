# checker spec for 0105 (see lib/engine.sh)
SEEDS=1
ENV=(HOME=/tmp/lab-home-$RANDOM)
extra_check() { must_use '\$HOME' '\$PATH'; }
