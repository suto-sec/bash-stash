# medium-02 · Preparar ficheros de configuración

**Nivel:** medio · **Script:** `stage_configs.sh`

Escribe un script de shell llamado `stage_configs.sh` que reciba un argumento opcional:

```
stage_configs.sh [directorio]
```

El script busca bajo `directorio` (incluidos todos sus subdirectorios) **ficheros regulares** (ni directorios ni enlaces simbólicos) que cumplan **todas** estas condiciones, y los copia al directorio `$HOME/staging`:

- el nombre termina en `.conf` o `.cfg` (en minúsculas);
- el tamaño es **mayor que 1024 bytes** (un fichero de exactamente 1024 bytes no cuenta);
- el fichero **no está dentro de un directorio llamado `old`**, a ninguna profundidad.

Solo se conserva el nombre del fichero (`directorio/net/hosts.conf` pasa a ser `$HOME/staging/hosts.conf`). Si un fichero ya existe en el destino se sobrescribe; los demás ficheros del destino no se tocan. Los nombres pueden contener espacios.

Reglas:

1. Más de un argumento: mensaje de error **y el uso correcto**, código **1**.
2. `directorio` no existe: mensaje de error que incluya su nombre, código **2**.
3. `directorio` existe pero no es un directorio: mensaje de error que incluya su nombre, código **3**.
4. Sin argumento: se usa el directorio actual.
5. Si `$HOME/staging` no existe, se crea y se escribe `Created /home/.../staging` (la ruta completa del directorio).
6. Al final se escribe cuántos ficheros se han copiado, exactamente así (también cuando es cero): `Staged N files`.

Los errores van a la salida de error. Los mensajes de las reglas 5 y 6 van a la salida estándar.

No olvides:
- Comprobación de argumentos y mensajes de error, en el orden correcto (3 puntos).
- Elegir exactamente los ficheros descritos: sufijo, tamaño, solo ficheros regulares, saltarse `old` (3 puntos).
- Crear `$HOME/staging` con su mensaje y sobrescribir las copias existentes (2 puntos).
- Contar los ficheros copiados e imprimir el mensaje final, también con el directorio actual y con cero ficheros (2 puntos).
