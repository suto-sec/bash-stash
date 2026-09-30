# checker spec for 0546 (see lib/engine.sh)
SCRIPT_NAME=subjstats.sh
SEEDS=3
COMPARE="stdout exit errmsg"
ARGS=('notas.txt' 'notas.txt SO' '"grades 2026.txt"' '"grades 2026.txt" "Bases de Datos"' 'comments.txt' 'notas.txt Mates2' 'notas.txt SO extra' '' 'nofile.txt' 'notas.txt Fisica')
setup() {
  local i n
  n=$(randr 10 22)
  { echo "# student;subject;grade"
    for ((i = 0; i < n; i++)); do
      [[ $(rand 6) == 0 ]] && echo
      echo "$(pick Ana Luis Marta Diego Eva Juan Sara Iker Nerea Jon);$(pick SO SO2 Redes Mates Mates2);$(pick 0 3 4 5 5 7 8 10 10)"
    done
  } > notas.txt
  n=$(randr 4 9)
  for ((i = 0; i < n; i++)); do
    echo "$(pick Ana Luis Marta Diego Eva Juan);$(pick "Bases de Datos" "Bases" SO);$(randr 0 10)"
  done > "grades 2026.txt"
  printf '# nothing yet\n\n# still nothing\n' > comments.txt
}
extra_check() {
  [[ -n $REF_ERR && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *subjstats.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
