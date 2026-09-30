# checker spec for 1544 (see lib/engine.sh)
SCRIPT_NAME=dup_files.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "arbol/sub uno/x" "arbol/sub dos"
  local c1 c2 c3
  c1=$(randtext 2); c2=$(randtext 3); c3=$(randtext 1)
  mkf "arbol/a $(word)1.txt" "$c1"
  mkf "arbol/sub uno/b $(word)2.txt" "$c1"
  mkf "arbol/sub dos/c $(word)3.txt" "$c2"
  mkf "arbol/sub uno/x/d $(word)4.txt" "$c2"
  mkf "arbol/e $(word)5.txt" "$c3"
  mkf "arbol/sub dos/f1.txt" "abcde"
  mkf "arbol/f2.txt" "vwxyz"
  touch "arbol/vacio1.txt" "arbol/sub dos/vacio2.txt"
  touch nota.txt
}
ARGS=('arbol' '' 'arbol extra' 'noexiste' 'nota.txt')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[0]}"
  must_use read
}
