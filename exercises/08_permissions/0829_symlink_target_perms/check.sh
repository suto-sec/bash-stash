# checker spec for 0829 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir enlaces
  local i f names=()
  for i in 1 2 3; do
    f=$(pick "$(word)$i.txt" "$(word) $i.dat")
    randtext 1 > "enlaces/$f"
    chmod "$(pick 644 600 640 755 700)" "enlaces/$f"
    names+=("$f")
  done
  ln -s "${names[0]}" "enlaces/link_a"
  ln -s "$PWD/enlaces/${names[1]}" "enlaces/link_b abs"
  ln -s "no_existe_$(word)" "enlaces/roto"
}
