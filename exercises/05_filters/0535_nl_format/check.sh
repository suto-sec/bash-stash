# checker spec for 0535 (see lib/engine.sh)
setup() {
  local i n; n=$(randr 6 14)
  for ((i = 0; i < n; i++)); do
    case $(rand 5) in
      0) echo ;;
      1) echo "PRINT \"$(word)\"" ;;
      2) echo "LET $(pick A B C) = $(randr 1 99)" ;;
      3) echo "GOTO $(randr 1 9)0" ;;
      *) echo "REM $(words 2)" ;;
    esac
  done > programa.bas
}
