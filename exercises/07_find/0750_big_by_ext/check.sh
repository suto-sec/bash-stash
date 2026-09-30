# checker spec for 0750 (see lib/engine.sh)
SCRIPT_NAME=big_by_ext.sh
SEEDS=2
setup() {
  mkdir -p repo/a repo/b/c
  local i f sz ext
  for i in $(seq 18); do
    ext=$(pick c c h md txt c '')
    if [[ -n $ext ]]; then f="repo/$(pick . a b/c)/$(word)$i.$ext"; else f="repo/$(pick . a b/c)/$(word)$i"; fi
    sz=$(pick 50000 60000 150000 200000 300000 120000)
    bigfile "$f" "$sz"
  done
}
ARGS=('repo' '"$W/repo"')
