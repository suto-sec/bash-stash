# checker spec for 1808 (see lib/engine.sh)
SCRIPT_NAME=podar.sh
COMPARE="stdout exit errmsg files"
setup() { mkdir -p proyecto/{src,img}; local i; for i in $(seq 7); do bigfile "proyecto/$(pick src img .)/$(word)$i.$(pick c png txt)" "$(pick 100 5000 8192 8193 20000 1000000)"; done; tar -czf pack.tgz proyecto; rm -r proyecto; echo "not a tar" > roto.tgz; }
ARGS=('pack.tgz' 'pack.tgz 4' 'pack.tgz 1000' 'roto.tgz' 'noexiste.tgz' '' 'pack.tgz abc' 'pack.tgz 0')
