# checker spec for 1017 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir -p "logs/app server" logs/old
  local i
  for i in $(seq 9); do
    bigfile "logs/$(pick . 'app server' old)/$(word)$(pick '' ' ' '_')$i$(pick .log .log .log .txt .log.1)" "$(pick 300 2048 2049 5000 9000)"
  done
  bigfile "logs/app server/access $(word).log" 4000
  bigfile "logs/dir$(word).log/inside.txt" 3000
}
extra_check() { must_use xargs; }
