# checker spec for 1524 (see lib/engine.sh)
SEEDS=4
setup() { local i; for i in $(seq "$(randr 2 4)"); do randtext "$(randr 0 6)" > "$(word)$(pick '' ' ' ' de ')$i.txt"; done; touch notas.md; }
input() {
  local n i m
  m=( *.txt ); n=${#m[@]}
  for i in $(seq "$(randr 2 6)"); do pick "$(randr 1 "$n")" "$(randr 1 "$n")" 0 $((n + 2)) abc; done
  [[ $(rand 3) != 0 ]] && echo $((n + 1))
  echo 1
}
extra_check() { must_use select; }
