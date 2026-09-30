# checker spec for 0742 (see lib/engine.sh)
setup() {
  mkdir -p cache/keep/sub cache/keeper cache/other
  local i f
  for i in $(seq 12); do
    f="cache/$(pick . keep keep/sub keeper other)/$(word)$i$(pick .tmp .cache .txt .tmpx)"
    touch "$f"
  done
  touch cache/keep.tmp
}
