# checker spec for 1326 (see lib/engine.sh)
SCRIPT_NAME=mkproj.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  local t
  t=$(word)$(randr 1 9)
  mkdir -p "$t/src"; echo "# $t" > "$t/README"; echo "$t" > taken
  echo "$(word)_$(randr 10 99)$(pick '' -x _y) $(pick sh py c)" > newargs
  echo "$(word)" > "note$(randr 1 3)"
  echo notes > notes
}
ARGS=('demo' 'tool_1 c' 'my-proj py' '$(cat newargs)' '$(cat taken)' '$(cat taken) py' 'notes sh' '"bad name"' '9lives' '_x' 'ok java' 'x-y SH' '' 'a b c' 'ok ""' 'bad.name c')
extra_check() {
  local tok
  if [[ $REF_CODE == [234] ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
