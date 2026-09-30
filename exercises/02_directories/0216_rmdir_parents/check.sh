# checker spec for 0216 (see lib/engine.sh)
COMPARE="stdout exit files"
SEEDS=4
setup() {
  local n p="" i k
  n=$(randr 3 5)
  for ((i = 1; i <= n; i++)); do p="$p${p:+/}$(word)$i"; done
  mkdir -p "$p"; echo "$p" > leaf.txt
  k=$(randr 0 $((n - 1)))
  if ((k > 0)); then
    local q; q=$(echo "$p" | cut -d/ -f1-"$k")
    if [[ $(rand 2) == 1 ]]; then echo data > "$q/$(word).txt"; else mkdir "$q/.$(word)"; fi
  fi
  mkdir -p "other/$(word)"
}
extra_check() { must_use rmdir; must_not_use 'rm'; }
