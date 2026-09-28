# checker spec for 0610 (see lib/engine.sh)
setup() { local i; for i in $(seq 18); do pick "log" "login ok" "the log file" "blog" "log-in" "catalog" "log." "syslog" "a log"; done > palabras.txt; }
