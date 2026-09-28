# checker spec for 0404 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { local d; d="etc/$(word)/$(word)"; mkdir -p "$d" etc/other; printf '[main]\nuser=%s\nport=%s\n' "$(word)" "$(randr 1000 9999)" > "$d/config.ini"; randtext 3 > etc/other/readme; randtext 3 > etc/other/config.bak; tar -czf backup.tgz etc; rm -r etc; }
