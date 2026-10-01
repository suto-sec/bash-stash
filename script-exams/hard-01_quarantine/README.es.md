# hard-01 · Cuarentena para ficheros escribibles por todos

**Nivel:** difícil · **Script:** `quarantine.sh`

Escribe un script de shell llamado `quarantine.sh` que admita un argumento opcional:

```
quarantine.sh [directorio]
```

El script mueve al directorio `$HOME/quarantine` todos los **ficheros regulares** (no directorios, no enlaces simbólicos) situados bajo `directorio` (incluyendo sus subdirectorios) que **tengan permiso de escritura para "otros"** (el permiso `o+w`) y cuyo nombre **no termine en `.tmp`**. Cada fichero movido debe perder el permiso de escritura para otros (`o-w`).

- Si se pasa más de un argumento, escribe por la salida de error un mensaje de error **y el uso correcto** y termina con código **1**.
- Si `directorio` no existe, escribe por la salida de error un mensaje que incluya el nombre y termina con código **2**.
- Si `directorio` existe pero no es un directorio, escribe por la salida de error un mensaje que incluya el nombre y termina con código **3**.
- Si no se pasa ningún argumento, se usa el directorio actual.
- Si `$HOME/quarantine` no existe, créalo y escribe por la salida estándar exactamente `Directory <ruta completa> created`.
- Procesa los ficheros en orden alfabético de su ruta completa (como lo ordena `sort`). Si ya existe en la cuarentena un fichero con el mismo nombre (de antes, o movido antes en esta ejecución) **no** debe sobrescribirse: guarda el nuevo como `<nombre>.1`, o `<nombre>.2`, ... usando el primer número libre.
- Un fichero puede no poder moverse (por ejemplo porque su directorio es de solo lectura). Entonces escribe `could not move <ruta>` por la salida de error y sigue con el siguiente; no cuenta.
- Al final escribe por la salida estándar exactamente `Quarantined N files`, donde `N` es el número de ficheros movidos con éxito (siempre en plural, aunque `N` sea 0 o 1).
- Si al menos un fichero no pudo moverse, termina con código **4** después de escribir el resumen; en caso contrario, con código 0.

Los nombres de ficheros y directorios pueden contener espacios.

No olvides:
- Comprobación de argumentos y mensajes de error (2 puntos).
- Crear `$HOME/quarantine` y presentar el mensaje (1 punto).
- Elegir los ficheros correctos: permiso, tipo, nombre y recursividad (2 puntos).
- No sobrescribir nunca: los sufijos `.1`, `.2`, ... en orden alfabético (2 puntos).
- Ficheros que no se pueden mover: mensaje, cuenta y código 4 (2 puntos).
- El script completo funcionando sobre el directorio actual (1 punto).
