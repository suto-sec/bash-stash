# checker spec for 0749 (see lib/engine.sh)
SCRIPT_NAME=depth_report.sh
SEEDS=2
setup() {
  mkdir -p arbol/a/b/c arbol/d
  local i f depth
  for i in $(seq 12); do
    depth=$(pick 1 1 2 2 3)
    case $depth in
      1) f="arbol/$(word)$i.txt" ;;
      2) f="arbol/$(pick a d)/$(word)$i.txt" ;;
      3) f="arbol/a/b/$(pick c c .)/$(word)$i.txt" ;;
    esac
    touch "$f"
  done
  touch "arbol/.oculto1" "arbol/a/.oculto2" "arbol/a/b/c/.oculto3"
}
ARGS=('arbol' '"$W/arbol"')
