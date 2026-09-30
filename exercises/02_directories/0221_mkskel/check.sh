# checker spec for 0221 (see lib/engine.sh)
SCRIPT_NAME=mkskel.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  local a b c
  a=$(word) b=$(word) c=$(word)
  {
    echo "# skeleton for $(word)"
    echo "$a/src"
    echo "$a/src/$b"
    echo ""
    echo "docs/user guide"
    echo "$(pick "/etc/$c" "/tmp/$c")"
    echo "$(pick "../$c" "$a/../$c" "$a/.." "..")"
    echo "v1..2/$c"
    echo "notes.txt/$b"
    echo "   # not a comment: starts with spaces"
    echo "$a/src"
    echo "$(pick "tests/$c" "tests/$c $b" "$b/$c/data")"
  } > spec.txt
  printf '%s\n' "# nothing" "" "$a/lib" "$b/bin" > ok.txt
  mkdir -p "out/$a/src" "destino existente/docs"
  touch out/notes.txt "destino existente/notes.txt" fichero
  cp spec.txt nolee.txt; chmod 000 nolee.txt
}
ARGS=('spec.txt out' 'spec.txt "destino existente"' 'ok.txt "nuevo/proyecto 1"' 'ok.txt "$W/out"' 'nolee.txt out' 'noexiste out' 'out out' 'spec.txt fichero' 'spec.txt' '')
extra_check() {
  local a=(); mapfile -t a < <(cd "$W" && eval "set -- $CASE" && printf '%s\n' "$@")
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[1]}"
  true
}
