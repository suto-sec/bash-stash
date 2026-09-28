# checker spec for 1312 (see lib/engine.sh)
setup() { printf 'SERVER=%s.example.org\nPORT=%s\ncd /tmp\n' "$(word)" "$(randr 1000 9999)" > config.sh; }
