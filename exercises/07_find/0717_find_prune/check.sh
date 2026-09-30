# checker spec for 0717 (see lib/engine.sh)
setup() {
  mkdir -p proj/src/lib proj/node_modules/pkg/dist proj/src/node_modules/left proj/.git/hooks proj/node_modules_old proj/docs
  local i d
  for i in $(seq 16); do
    d=$(pick proj proj/src proj/src/lib proj/node_modules/pkg proj/node_modules/pkg/dist proj/src/node_modules/left proj/.git/hooks proj/node_modules_old proj/docs proj/src)
    touch "$d/$(word)$i$(pick .js .js .ts .json .js.map)"
  done
  touch proj/src/node_modules.js "proj/docs/$(word) app.js" "proj/.git/hooks/$(word).js"
  mkdir -p "proj/src/$(word).js"
}
extra_check() { must_use -prune; }
