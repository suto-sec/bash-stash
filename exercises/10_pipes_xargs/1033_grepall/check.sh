# checker spec for 1033 (see lib/engine.sh)
SCRIPT_NAME=grepall.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i j line pool=(linux Linux LINUX shell Shell shells kernel linux_kernel apple banana
                       cherry the and of a is linux-ish shell2 KERNEL)
  for i in $(seq "$(randr 15 30)"); do
    line=""
    for j in $(seq "$(randr 2 8)"); do line+="$(pick "${pool[@]}") "; done
    echo "${line% }"
  done > texto.txt
  { echo "Shell and linux and apple"; randtext 3; echo "apple banana cherry"; } > "mis notas.txt"
  mkdir adir
}
ARGS=('texto.txt linux' 'texto.txt shell KERNEL' 'texto.txt linux shell kernel' '"mis notas.txt" apple' '"$W/mis notas.txt" APPLE banana cherry' 'texto.txt zzz' 'texto.txt' 'nope.txt a' 'adir a' 'texto.txt shell l1nux x_y' 'texto.txt "two words"')
extra_check() {
  [[ $REF_CODE == 3 ]] && { [[ $ERR == *l1nux* || $ERR == *"two words"* ]] || fail "the message should name the bad word"; }
  true
}
