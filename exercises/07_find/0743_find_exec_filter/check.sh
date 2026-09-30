# checker spec for 0743 (see lib/engine.sh)
setup() {
  mkdir -p registros/descartados registros/sub
  local i f n
  for i in $(seq 10); do
    f="registros/$(pick . sub descartados)/$(word)$i.log"
    n=$(randr 1 5)
    randtext "$n" > "$f"
    case $(rand 3) in
      0) echo ERROR >> "$f" ;;
      1) echo "ERRORCODE99" >> "$f" ;;
      2) : ;;
    esac
  done
  : > registros/vacio.log
  echo ERROR > registros/descartados/oculto.log
}
