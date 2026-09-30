# checker spec for 0327 (see lib/engine.sh)
SCRIPT_NAME=skeleton.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p "src/a b/c" src/.oculto src/d/e/f existe
  local i f
  for i in $(seq 1 8); do
    f="src/$(pick . "a b" "a b/c" .oculto d/e d/e/f)/$(pick "$(word)$i.txt" "$(word) $i" ".h$i")"
    randtext 2 > "$f"
    touch -d "20$(randr 10 24)-0$(randr 1 9)-1$(randr 0 9) 1$(randr 0 9):$(randr 10 59)" "$f"
  done
  chmod 600 "$f"
  ln -s ../../etc "src/a b/link"
  ln -s "$(basename "$f")" "src/d/l2"
  touch fich
}
ARGS=('src copia' 'src "$W/out/new copy"' '"src/a b" "x y"' 'src existe' 'fich z' 'noexiste z' 'src' '')
capture() { find . -type f -newermt 2025-01-01 -printf 'recent %p\n' | grep -v '^recent ./src/' | sort; find . -type f ! -newermt 2025-01-01 -printf '%p %TY-%Tm-%Td_%TH:%TM\n' | sort; }
