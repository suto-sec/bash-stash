# checker spec for 1413 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=tool.sh
COMPARE="stdout exit errmsg"
setup() { mkdir -p "mi dir" sub; touch fichero; }
ARGS=('' 'sub' '"mi dir"' 'fichero' 'noexiste' 'a b' 'sub sub' '/etc' '/etc/passwd')
extra_check() { [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"; true; }
