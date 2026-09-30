# checker spec for 1317 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=try.sh
COMPARE="stdout stderr exit"
setup() { mkdir sub; }
ARGS=('true' 'false' '' 'grep -q root /etc/passwd' 'grep -q zzzz /etc/passwd' 'ls -d "no such" /' 'test 3 -lt 5' 'nosuchcmd x' 'bash -c "exit 42"' 'mkdir sub' 'test -d sub')
