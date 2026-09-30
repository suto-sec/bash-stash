# checker spec for 1535 (see lib/engine.sh)
SCRIPT_NAME=resumen_dirs.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "proy a/src/x" "proy a/doc" b/c/d vacio/sub
  local i
  for i in $(seq "$(randr 3 7)"); do
    bigfile "$(pick 'proy a' 'proy a/src' 'proy a/src/x' 'proy a/doc' b b/c b/c/d)/$(pick '' .)$(word)$(pick '' ' ')$i" "$(randr 0 3)00"
  done
  echo x > f.txt
}
ARGS=('"proy a"' '"proy a" b' 'b vacio' '' 'b f.txt nada' '"$W/b"' 'vacio/sub')
extra_check() {
  [[ $CASE == *f.txt* ]] && { mentions f.txt; mentions nada; }
  true
}
