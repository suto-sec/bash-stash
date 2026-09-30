# checker spec for 0638 (see lib/engine.sh)
setup() {
  local n i maj min pat
  n=$(randr 3 5)
  : > versiones.txt
  for i in $(seq "$n"); do
    maj=$(pick 0 1 2 3 9 10 20 "$(randr 0 99)")
    min=$(pick 0 1 2 5 9 "$(randr 0 99)")
    pat=$(pick 0 1 3 7 22 "$(randr 0 99)")
    echo "$(word) $maj.$min.$pat $(word)" >> versiones.txt
  done
  echo "otra vez $maj.$min.$pat visto de nuevo" >> versiones.txt
  echo "bad 0$(randr 1 9).2.3 here" >> versiones.txt
  echo "too.short $(randr 1 9).$(randr 1 9) end" >> versiones.txt
  echo "letters $(randr 1 9).x.$(randr 1 9) skip" >> versiones.txt
  echo "glued v$(randr 10 99).0.0 shipped" >> versiones.txt
}
