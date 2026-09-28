# checker spec for 0515 (see lib/engine.sh)
setup() { { echo "# config"; local i; for i in $(seq 8); do case $(rand 4) in 0) echo "# $(words 3)";; 1) echo;; *) echo "$(pick port host user timeout)_$i = $(randr 1 9999)";; esac; done; echo "port = 22"; } > config.conf; }
extra_check() { must_use sed; }
