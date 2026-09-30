# checker spec for 0333 (see lib/engine.sh)
setup() {
  mkdir almacen
  local n1 n2 n3 content1
  n1=$(word); n2=$(word); n3=$(word)
  content1=$(randtext 2)
  printf '%s\n' "$content1" > "almacen/${n1}_1"
  ln "almacen/${n1}_1" "almacen/${n1}_2"
  ln "almacen/${n1}_1" "almacen/${n1}_3"
  printf '%s\n' "$(randtext 2)" > "almacen/${n2}_1"
  ln "almacen/${n2}_1" "almacen/${n2}_2"
  printf '%s\n' "$content1" > "almacen/${n3}_copy"
  local i
  for i in $(seq "$(randr 2 4)"); do randtext 1 > "almacen/$(pick "$(word)_solo$i" "$(word) solo$i")"; done
  ln -s "${n1}_1" "almacen/zz_sym"
}
extra_check() { must_use -ef; }
