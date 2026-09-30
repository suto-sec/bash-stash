# checker spec for 1521 (see lib/engine.sh)
SEEDS=4
setup() {
  local i j l
  for i in $(seq "$(randr 3 7)"); do
    if [[ $(rand 5) == 0 ]]; then echo; continue; fi
    l=$(pick '' '  ' '	')
    for j in $(seq "$(randr 1 6)"); do l+="$(word)$(pick ' ' '   ' '	' ' ')"; done
    echo "$l"
  done > frases.txt
}
extra_check() { must_use read; }
