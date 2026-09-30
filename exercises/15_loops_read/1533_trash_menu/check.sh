# checker spec for 1533 (see lib/engine.sh)
SCRIPT_NAME=papelera.sh
SEEDS=4
COMPARE="stdout exit errmsg files"
setup() {
  local d i n
  for d in caja "mi carpeta"; do
    mkdir -p "$d"
    for i in $(seq "$(randr 1 4)"); do randtext 1 > "$d/$(word)$(pick '' ' ' ' de ')$i.txt"; done
    touch "$d/.oculto"; mkdir "$d/sub"
  done
  mkdir "caja/.trash"; n=$(word); echo a > "caja/.trash/$n.txt"; echo b > "caja/$n.txt"; echo c > "caja/.trash/viejo.txt"
}
input() {
  local i names=()
  while IFS= read -r i; do names+=("${i##*/}"); done < <(find . -type f | sort)
  for i in $(seq "$(randr 4 9)"); do
    case $(rand 6) in
      0) echo 1 ;;
      1|2) echo 2; pick "${names[@]}" "${names[@]}" "nada.txt" ;;
      3|4) echo 3; pick "${names[@]}" "viejo.txt" ;;
      5) pick 7 x ;;
    esac
  done
  [[ $(rand 3) != 0 ]] && echo 4
  echo 1
}
ARGS=('caja' '"mi carpeta"' '' 'caja x' 'nada')
extra_check() { [[ $CASE == nada ]] && mentions nada; must_use select; }
