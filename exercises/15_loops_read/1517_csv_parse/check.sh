# checker spec for 1517 (see lib/engine.sh)
setup() { echo "nombre,apellido,nota" > alumnos.csv; local i; for i in $(seq "$(randr 3 8)"); do echo "$(pick Ana Luis Eva Pedro Marta Sofia Jose),$(pick garcia lopez perez sanz ruiz),$(randr 0 10)"; done >> alumnos.csv; }
