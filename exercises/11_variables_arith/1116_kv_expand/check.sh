# checker spec for 1116 (see lib/engine.sh)
setup() {
  local k v
  k=$(word); k=${k^^}
  v="/$(pick var etc opt usr srv)/$(word)/$(word).$(pick log conf txt)"
  echo "$k=$v" > config.txt
}
extra_check() { must_not_use cut sed basename dirname; }
