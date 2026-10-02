# checker spec for 2008 (see lib/engine.sh)
SEEDS=3
setup() {
  local i l
  for i in $(seq 10); do l=$(pick "ana garcia" "Ana Ruiz" "ANA PEREZ" "mariana lopez" "anabel perez" "luis soto" "eva diaz" "joana ruiz" "pedro ana soto"); echo "$l"; done > usuarios.txt
  sed -i '3s/.*/Ana Ruiz/;7s/.*/anabel diaz/' usuarios.txt
}
extra_check() { must_use grep; }
