# checker spec for 1032 (see lib/engine.sh)
SCRIPT_NAME=cmpdirs.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i f
  mkdir -p "v1/sub dir" v1/lib "v2 new"
  for i in $(seq "$(randr 5 9)"); do
    f="$(pick . 'sub dir' lib)/$(word)$(pick '' ' ')$i.$(pick txt c)"
    echo "$(word) $i" > "v1/$f"
  done
  echo x > "v1/lib/conflict"
  cp -r v1/. "v1 copy"
  cp -r v1/. "v2 new"
  rm "v2 new/lib/conflict"; mkdir "v2 new/lib/conflict"
  for f in "v2 new"/*.* "v2 new/sub dir"/* "v2 new"/lib/*; do
    [[ -f $f ]] || continue
    case $(rand 4) in 0) echo changed >> "$f" ;; 1) rm "$f" ;; esac
  done
  mkdir -p "v2 new/extra"; echo new > "v2 new/extra/new $(word).txt"
  touch afile
}
ARGS=('v1 "v2 new"' '"v2 new" v1' 'v1 "v1 copy"' '"$W/v1/sub dir" "v2 new/sub dir"' 'v1' 'v1 nope' 'afile v1' 'a b c')
extra_check() {
  [[ $REF_CODE == 3 ]] && { [[ $ERR == *nope* || $ERR == *afile* ]] || fail "the message should include the bad directory"; }
  true
}
