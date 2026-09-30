# checker spec for 0532 (see lib/engine.sh)
setup() {
  local i n s d
  d() { printf '%02d/%02d/%04d' "$(randr 1 28)" "$(randr 1 12)" "$(randr 1990 2030)"; }
  n=$(randr 4 8)
  for ((i = 0; i < n; i++)); do
    case $(rand 3) in
      0) echo "Meeting on $(d) with $(word), moved to $(d)." ;;
      1) echo "$(word) ratio $(randr 1 9)/$(randr 1 9), version $(randr 1 9)/$(randr 10 99)/$(randr 1 9)" ;;
      *) echo "Due $(d): $(words 3)" ;;
    esac
  done > notas.txt
  n=$(randr 3 7)
  for ((i = 0; i < n; i++)); do s=$(word); d=$(word); echo "${s^}, ${d^}: 6$(randr 10000000 99999999)"; done > contactos.txt
  unset -f d
}
extra_check() { must_use sed; }
