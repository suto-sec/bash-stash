# medium-01 · Informe de stock bajo

**Nivel:** medio · **Script:** `lowstock.sh`

Escribe un script de shell llamado `lowstock.sh` que reciba un fichero y un umbral opcional:

```
lowstock.sh fichero [umbral]
```

`fichero` es un inventario en CSV. Su primera línea es una cabecera (`item,qty,price`) y cada una de las demás es `nombre,qty,price`, con `qty` y `price` enteros no negativos. Los nombres no contienen comas pero pueden contener espacios. Pueden aparecer líneas en blanco, que se ignoran.

El script imprime los artículos cuyo `qty` es **menor que** `umbral` (por defecto **5**), uno por línea con el formato `nombre: qty`, ordenados por cantidad de menor a mayor y, a igual cantidad, por nombre en orden alfabético. A continuación imprime dos líneas de resumen:

```
Low stock items: N
Total value: V
```

donde `N` es cuántos artículos se han listado y `V` la suma de `qty * price` de esos artículos (`0` y `0` si no hay ninguno; entonces solo se imprimen las dos líneas de resumen).

Errores (los mensajes van a la salida de error). Compruébalos en este orden:

1. Ningún argumento, o más de dos: mensaje de error **y el uso correcto**, código **1**.
2. `fichero` no existe o no es un fichero regular: mensaje de error que incluya su nombre, código **2**.
3. `fichero` no se puede leer: mensaje de error que incluya su nombre, código **4**.
4. `umbral` no es un entero positivo (solo dígitos, al menos 1): mensaje de error que incluya el valor, código **3**.

No olvides:
- Comprobación de argumentos y mensajes de error, en el orden correcto (3 puntos).
- Seleccionar los artículos, ordenarlos e imprimirlos con el formato exacto y el valor por defecto correcto (4 puntos).
- Casos especiales: ningún artículo bajo, líneas en blanco, nombres con espacios, empates en la cantidad (3 puntos).
