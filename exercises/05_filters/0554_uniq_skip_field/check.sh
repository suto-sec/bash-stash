# checker spec for 0554 (see lib/engine.sh)
setup() {
  local n i j reps msg hh
  n=$(randr 4 7)
  hh=0
  : > estado.log
  for i in $(seq "$n"); do
    msg=$(pick "disco ok" "red activa" "cpu alta" "memoria baja" "servicio activo")
    reps=$(randr 1 4)
    for j in $(seq "$reps"); do
      hh=$((hh + 1))
      printf '%02d:%02d:00 %s\n' $((hh / 60)) $((hh % 60)) "$msg" >> estado.log
    done
  done
}
