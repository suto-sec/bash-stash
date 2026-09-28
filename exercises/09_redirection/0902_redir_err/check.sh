# checker spec for 0902 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { local i n=(); for i in $(seq 6); do n+=("$(word)$i"); done; for i in 0 2 4; do touch "${n[$i]}"; done; [[ $(rand 2) == 1 ]] && touch "${n[1]}"; printf '%s\n' "${n[@]}" > nombres.txt; }
