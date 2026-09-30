# checker spec for 1721 (see lib/engine.sh)
SCRIPT_NAME=groupsize.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i k m
  for i in $(seq "$(randr 6 12)"); do
    m=; for k in $(seq "$(rand 5)"); do m+=${m:+,}$(word)$k; done
    echo "$(word)$i:x:$((1000 + i)):$m"
  done > "grupos lab"
}
ARGS=('' '"grupos lab"' '/etc/group' 'noexiste' 'a b')
