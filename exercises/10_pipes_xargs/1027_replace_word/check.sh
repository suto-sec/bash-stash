# checker spec for 1027 (see lib/engine.sh)
SCRIPT_NAME=replace.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  local i f
  mkdir -p "docs/my notes" docs/src/deep
  for i in $(seq "$(randr 6 10)"); do
    f="docs/$(pick . 'my notes' src src/deep)/$(word)$(pick '' ' ')$i$(pick .txt .txt .txt .md .txt.bak)"
    { randtext "$(randr 1 5)"; echo "$(pick kernel apple kernelspace '') $(pick kernel apple pear) kernel"; } > "$f"
  done
  mkdir -p "docs/dir$(word).txt"
  echo "kernel kernel" > "docs/src/kernel notes.txt"
  echo "apple" > outside.txt
  touch afile
}
ARGS=('kernel KERNEL docs' 'apple pear_2 "docs/my notes"' 'zzz yyy docs' 'kernel core_ "$W/docs/src"' 'kernel x' 'a-b x docs' 'kernel "x y" docs' 'kernel x noexiste' 'kernel x afile' 'kernel x docs extra')
extra_check() {
  [[ $REF_CODE == 2 ]] && { [[ $ERR == *a-b* || $ERR == *"x y"* ]] || fail "the message should name the bad argument"; }
  true
}
