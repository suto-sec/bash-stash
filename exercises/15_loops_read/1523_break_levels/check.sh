# checker spec for 1523 (see lib/engine.sh)
SEEDS=5
setup() {
  local i j l
  for i in $(seq "$(randr 3 7)"); do
    l=
    for j in $(seq "$(randr 2 6)"); do
      case $(rand 12) in 0) l+="0 " ;; 1) [[ $i -gt 1 ]] && l+="FIN " || l+="1 " ;; *) l+="$(randr -9 20) " ;; esac
    done
    echo "${l% }"
  done > matriz.txt
}
extra_check() { must_use break continue; }
