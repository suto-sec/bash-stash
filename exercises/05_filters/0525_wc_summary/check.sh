# checker spec for 0525 (see lib/engine.sh)
setup() {
  local i n; n=$(randr 8 20)
  for ((i = 0; i < n; i++)); do
    case $(rand 5) in
      0) echo ;;
      1) echo "$(words 2) canción $(word) año" ;;
      *) words "$(randr 1 9)" ;;
    esac
  done > texto.txt
}
extra_check() { must_use wc; }
