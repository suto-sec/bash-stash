# checker spec for 1324 (see lib/engine.sh)
SCRIPT_NAME=colsum.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local r ncol c line
  ncol=$(randr 3 5)
  line=id; for ((c = 2; c <= ncol; c++)); do line+=",$(word)$c"; done
  echo "$line" > "sales 2024.csv"
  for ((r = 1; r <= $(randr 3 8); r++)); do
    line=$r; for ((c = 2; c <= ncol; c++)); do line+=",$(randr -50 500)"; done
    echo "$line" >> "sales 2024.csv"
  done
  echo "code;$(word)A;$(word)B" > stock.txt
  for ((r = 0; r < $(randr 2 6); r++)); do echo "$(randr 100 999);$(randr 0 40);$(randr -5 5)" >> stock.txt; done
  echo "a,b" > locked.csv; chmod 000 locked.csv
  mkdir sub
}
ARGS=('"sales 2024.csv" 2' '"sales 2024.csv" 3 2 3' '-d ";" stock.txt 3 1' 'stock.txt 2' '"sales 2024.csv" 6' '"sales 2024.csv" 0' '"sales 2024.csv" x' 'nofile 1' 'locked.csv 1' '' '"sales 2024.csv"' '-d' '-d ";"' '-d ";;" stock.txt 1' 'sub 1' '-d , "$W/sales 2024.csv" 1')
extra_check() {
  local tok
  if [[ $REF_CODE == [23] ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
