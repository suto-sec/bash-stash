# checker spec for 0422 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir -p proyecto/src proyecto/doc
  local i f
  {
    for i in 1 2 3 4 5; do
      f=$(pick "src/$(word)$i.c" "doc/$(word)$i.md" "$(word)$i.txt" "doc/$(word) $i.txt")
      randtext "$(randr 1 3)" > "proyecto/$f"
      echo "$f"
    done
    echo "src/no_existe_$(word).c"
    echo "doc/borrado_$(word).md"
    echo "src"
  } > lista.txt
}
