# checker spec for 0629 (see lib/engine.sh)
SCRIPT_NAME=wsearch.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "docs/sub dir" docs/old
  local f i j
  for f in docs/a.txt "docs/sub dir/my notes.txt" "docs/sub dir/b.txt" docs/old/x.txt docs/readme.md docs/c.txt.bak notes.txt file.txt; do
    for i in $(seq "$(randr 0 6)"); do
      for j in 1 2 3; do pick kernel Kernel KERNEL kernels kernel_x kernel-x linux Linux shell SHELL shells process; done | tr '\n' ' '
      echo
    done > "$f"
  done
}
ARGS=('kernel docs' 'Shell "docs/sub dir"' 'kernel "$W/docs"' 'linux' 'zzz docs' '' 'a b c' 'ker.nel docs' 'kernel nodir' 'kernel file.txt')
extra_check() {
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; [[ $REF_CODE == 2 ]] && echo "$1" || echo "$2")"
  true
}
