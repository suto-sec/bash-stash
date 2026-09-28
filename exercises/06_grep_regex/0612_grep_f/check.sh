# checker spec for 0612 (see lib/engine.sh)
setup() { local i b=(); for i in 1 2 3; do b+=("$(ip_rand)"); done; printf '%s\n' "${b[@]}" > blacklist.txt; for i in $(seq 20); do echo "conn $(pick "${b[@]}" "$(ip_rand)" "$(ip_rand)" "${b[0]//./x}") $(word)"; done > conexiones.log; }
