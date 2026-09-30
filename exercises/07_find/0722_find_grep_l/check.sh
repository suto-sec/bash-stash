# checker spec for 0722 (see lib/engine.sh)
setup() {
  mkdir -p etc/sys "etc/app conf/extra"
  local i f
  for i in $(seq 10); do
    f="etc/$(pick . sys 'app conf' 'app conf/extra')/$(word)$(pick '' ' ')$i$(pick .conf .conf .conf .conf.bak .txt)"
    { randtext "$(randr 1 4)"; pick 'debug = true' 'DEBUG=1' '# Debug mode' 'debugging off' 'log_debug on' 'level info' 'verbose yes'; randtext "$(randr 0 3)"; } > "$f"
  done
}
