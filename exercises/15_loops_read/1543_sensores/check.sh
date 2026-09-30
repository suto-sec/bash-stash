# checker spec for 1543 (see lib/engine.sh)
SEEDS=4
setup() {
  local i n ns sensors=() s val
  ns=$(randr 2 4)
  for i in $(seq "$ns"); do sensors+=("S$(word)$i"); done
  n=$(randr 6 14)
  for i in $(seq "$n"); do
    s=$(pick "${sensors[@]}")
    case $(rand 6) in
      0) val=$(randr -100 -51) ;;
      1) val=$(randr 151 300) ;;
      *) val=$(randr -50 150) ;;
    esac
    echo "$s $val"
  done > sensores.txt
}
extra_check() { must_use continue; }
