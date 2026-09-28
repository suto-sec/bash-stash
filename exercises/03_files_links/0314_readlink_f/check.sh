# checker spec for 0314 (see lib/engine.sh)
setup() { mkdir -p real; randtext 1 > real/file; local n; n=$(randr 2 4); ln -s real/file "link$n"; local i; for ((i=n-1;i>=1;i--)); do ln -s "link$((i+1))" "link$i"; done; }
