# checker spec for 0222 (see lib/engine.sh)
SCRIPT_NAME=lsd.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local d i
  for d in docs "mis cosas" vacio; do mkdir -p "$d"; done
  for d in docs "mis cosas"; do
    for i in $(seq "$(randr 2 5)"); do
      case $(rand 4) in
        0) mkdir "$d/$(word)$i" ;;
        1) touch "$d/$(word) $(word)$i.txt" ;;
        2) touch "$d/.$(word)$i" ;;
        *) mkdir "$d/.$(word)$i.d" ;;
      esac
    done
    touch "$d/$(word).pdf"
  done
  mkdir vacio/.solo; touch fichero.txt
}
ARGS=('docs' '-a docs' 'docs "mis cosas" vacio' '-a vacio "mis cosas" fichero.txt' 'noexiste docs' '"$W/docs" -a' '-a' '')
extra_check() { [[ $REF_CODE == 2 ]] && mentions "cannot list"; true; }
