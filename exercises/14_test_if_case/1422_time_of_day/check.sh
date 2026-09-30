# checker spec for 1422 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=when.sh
COMPARE="stdout stderr exit"
ARGS=('08:30 09:59 00:00 23:59 12:00 05:59 06:00 19:59 20:00 11:08' '24:00 7:30 12:60 ab:cd 1200 "" 08:09 " 08:09"' '' '09:09')
