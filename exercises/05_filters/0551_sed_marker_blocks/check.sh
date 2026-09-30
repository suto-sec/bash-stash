# checker spec for 0551 (see lib/engine.sh)
setup() {
  local nb i j nl
  nb=$(randr 3 5)
  : > bitacora.txt
  echo "$(word) inicio" >> bitacora.txt
  echo "BEGINNING no es una marca real" >> bitacora.txt
  for i in $(seq "$nb"); do
    echo "$(word) fuera $i" >> bitacora.txt
    echo "BEGIN" >> bitacora.txt
    nl=$(randr 1 4)
    for j in $(seq "$nl"); do echo "$(word)$j" >> bitacora.txt; done
    echo "END" >> bitacora.txt
  done
  echo "ENDED tampoco es una marca" >> bitacora.txt
  echo "$(word) final" >> bitacora.txt
}
