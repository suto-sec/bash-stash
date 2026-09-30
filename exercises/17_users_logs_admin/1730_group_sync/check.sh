# checker spec for 1730 (see lib/engine.sh)
SCRIPT_NAME=equipo.sh
SEEDS=3
RUN_AS_ROOT=1
COMPARE="stdout exit errmsg"
REAL=(alumno luke sally rod jgarcia mlopez pruiz rmartin rosa)
labclean() { sudo groupdel lab_team >/dev/null 2>&1; sudo groupdel lab_ops >/dev/null 2>&1; true; }
setup() {
  labclean
  local i m=
  if [[ $(rand 3) != 0 ]]; then
    sudo groupadd lab_team
    for i in 1 2 3; do m+=${m:+,}$(pick "${REAL[@]}"); done
    sudo gpasswd -M "$(echo "$m" | tr , '\n' | sort -u | tr '\n' , | sed 's/,$//')" lab_team >/dev/null
  fi
  for i in $(seq "$(randr 2 6)"); do pick "${REAL[@]}" "${REAL[@]}" "$(word)" ""; done > "the team.txt"
  printf '%s\n' "${REAL[1]}" "${REAL[2]}" > two.txt
}
capture() {
  getent group lab_team lab_ops | cut -d: -f1,4 | tr , ' '
  local u; for u in "${REAL[@]}"; do echo "$u: $(id -Gn "$u" | tr ' ' '\n' | sort | tr '\n' ' ')"; done
}
ARGS=('lab_team "the team.txt"' 'lab_ops two.txt' 'lab_team "$W/two.txt"' 'lab_team noexiste' 'lab_team' '')
extra_check() { labclean; }
