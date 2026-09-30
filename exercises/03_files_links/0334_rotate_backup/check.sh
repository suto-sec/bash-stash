# checker spec for 0334 (see lib/engine.sh)
SCRIPT_NAME=rotate_backup.sh
SEEDS=3
COMPARE="stdout exit errmsg files mtime"
setup() {
  randtext "$(randr 2 5)" > diario.log
  chmod "$(pick 644 600 640)" diario.log
  touch -d "2023-0$(randr 1 9)-1$(randr 0 8) 1$(randr 0 9):$(randr 10 59)" diario.log
  local n k
  n=$(pick 2 3 4)
  for ((k = 1; k <= n; k++)); do
    (( $(rand 4) == 0 )) && continue
    randtext 1 > "diario.log.$k"
    touch -d "2022-0$(randr 1 9)-1$(randr 0 8) 1$(randr 0 9):$(randr 10 59)" "diario.log.$k"
  done
  randtext 2 > "mi diario.log"
  chmod 640 "mi diario.log"
  randtext 1 > "mi diario.log.1"
  mkdir carpeta
  touch fich
}
ARGS=(
  'diario.log 3'
  'diario.log 1'
  '"$W/diario.log" 4'
  '"mi diario.log" 2'
  'diario.log 0'
  'diario.log abc'
  'diario.log'
  'noexiste.log 3'
  'carpeta 3'
  ''
)
extra_check() {
  case $REF_CODE in
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
