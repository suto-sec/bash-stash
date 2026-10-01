# easy-01 · El fichero más reciente

**Nivel:** fácil · **Script:** `newest.sh`

Escribe un script de shell llamado `newest.sh` que admita un argumento opcional:

```
newest.sh [directorio]
```

El script imprime el **fichero regular modificado más recientemente** que esté directamente dentro de `directorio` (no se entra en subdirectorios; los ficheros ocultos cuentan; los directorios no son ficheros), con este formato exacto:

```
<nombre> (<N> bytes)
```

donde `<nombre>` es el nombre del fichero sin su directorio y `<N>` su tamaño en bytes.

- Si se pasa más de un argumento, escribe por la salida de error un mensaje de error **y el uso correcto** y termina con código **1**.
- Si `directorio` no existe, escribe por la salida de error un mensaje que incluya el nombre y termina con código **2**.
- Si `directorio` existe pero no es un directorio, escribe por la salida de error un mensaje que incluya el nombre y termina con código **3**.
- Si no se pasa ningún argumento, se usa el directorio actual.
- Si el directorio no tiene ningún fichero regular, escribe un mensaje de error por la salida de error y termina con código **4**.
- Los nombres de fichero pueden contener espacios.

No olvides:
- Comprobación de argumentos y mensajes de error (3 puntos).
- Encontrar el fichero más reciente e imprimirlo con el formato exacto (4 puntos).
- Casos especiales: espacios en los nombres, ficheros ocultos, un directorio más reciente que todos los ficheros, un directorio sin ficheros (3 puntos).
