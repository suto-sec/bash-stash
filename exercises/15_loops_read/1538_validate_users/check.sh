# checker spec for 1538 (see lib/engine.sh)
SCRIPT_NAME=valida_usuarios.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local f i u id us=() ids=()
  for i in 1 2 3; do us+=("$(word)$i"); ids+=("$(randr 1000 3000)"); done
  for f in usuarios.txt "alta usuarios.txt"; do
    { echo "# user:uid:shell"
      for i in $(seq "$(randr 5 10)"); do
        u=$(pick "${us[@]}" "${us[@]}" "$(word)" "$(word)$i" "Ana" "3po" "$(word).x")
        id=$(pick "${ids[@]}" "$(randr 1000 60000)" "$(randr 1000 60000)" 999 "12a" 60001)
        case $(rand 9) in
          0) echo ;; 1) echo "$u:$id" ;; 2) echo "$u:$id:/bin/bash:x" ;;
          *) echo "$u:$id:$(pick /bin/bash /bin/bash /bin/sh /usr/sbin/nologin /bin/zsh)" ;;
        esac
      done; } > "$f"
  done
  printf '%s\n' "root$(randr 1 9):1000:/bin/bash" "$(word)z:2000:/bin/sh" > limpio.txt
}
ARGS=('usuarios.txt' '"alta usuarios.txt"' 'limpio.txt' '' 'a b' 'nada.txt')
extra_check() { [[ $CASE == nada.txt ]] && mentions nada.txt; true; }
