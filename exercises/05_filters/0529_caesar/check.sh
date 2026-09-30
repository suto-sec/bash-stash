# checker spec for 0529 (see lib/engine.sh)
ARGS=('3' '13' '0' '25' '7')
input() { local i w; for i in 1 2 3 4; do w=$(word); echo "$(word) ${w^}, $(word)! $(randr 1 99) ${w^^}?"; done; }
extra_check() { must_use tr; }
