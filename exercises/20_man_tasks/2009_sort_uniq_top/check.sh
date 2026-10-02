# checker spec for 2009 (see lib/engine.sh)
SEEDS=3
setup() {
  local a=($(ip_rand) $(ip_rand) $(ip_rand) $(ip_rand) $(ip_rand)) r i
  for r in 1 2 3 4 5; do for i in 0 1 2 3 4; do (( r <= 5 - i )) && echo "${a[i]}"; done; done > ips.txt
}
extra_check() { must_use sort uniq; }
