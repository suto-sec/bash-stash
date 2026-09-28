# checker spec for 1816 (see lib/engine.sh)
SCRIPT_NAME=rota.sh
COMPARE="stdout exit errmsg files"
setup() { mkdir -p logs; randtext 5 > logs/app.log; local i; for i in $(seq "$(randr 0 4)"); do echo "old $i $(word)" | gzip > "logs/app.log.$i.gz"; done; randtext 2 > logs/other.log; }
ARGS=('logs/app.log' 'logs/app.log 2' 'logs/app.log 5' 'logs/other.log 1' 'logs/nada.log' 'logs' 'logs/app.log 0' '')
