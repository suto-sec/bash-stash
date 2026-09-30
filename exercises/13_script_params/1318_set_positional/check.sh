# checker spec for 1318 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=fields.sh
COMPARE="stdout stderr exit"
ARGS=('"root:x:0:0:root:/root:/bin/bash"' '"a,b,,c" ,' '"one two  three" " "' '"a:b:"' '""' '"x;y" ,' '"a-b" --' '":lead"' '' 'a b c' '"a b" ""')
extra_check() { must_use set; }
