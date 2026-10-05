# medium-03 · Mensajes por servicio

**Nivel:** medio · **Script:** `svcerrors.sh`

Escribe un script de shell llamado `svcerrors.sh` que reciba un fichero de registro y un nivel opcional:

```
svcerrors.sh fichero [nivel]
```

Cada línea del registro tiene esta forma (campos separados por espacios):

```
2026-03-14 09:12:01 ERROR sshd: authentication failed for user bob
```

es decir: fecha, hora, **nivel** (`INFO`, `WARN` o `ERROR`), el **servicio** seguido de dos puntos (letras minúsculas, dígitos y guiones) y un mensaje libre que puede contener espacios, dos puntos e incluso las palabras `INFO`, `WARN` o `ERROR`. El fichero también puede contener líneas en blanco y líneas que no siguen esta forma (por ejemplo `-- log rotated --`): se ignoran.

El script cuenta, para las líneas cuyo nivel es **exactamente** `nivel` (por defecto `ERROR`), cuántas hay por servicio, e imprime una línea por servicio con la forma `servicio: N`, ordenadas por `N` de mayor a menor y, a igual `N`, por nombre de servicio en orden alfabético. Después imprime una última línea:

```
Total: T
```

donde `T` es el número de líneas contadas (solo `Total: 0` si no hay ninguna).

Errores (los mensajes van a la salida de error). Compruébalos en este orden:

1. Ningún argumento, o más de dos: mensaje de error **y el uso correcto**, código **1**.
2. `fichero` no existe o no es un fichero regular: mensaje de error que incluya su nombre, código **2**.
3. `fichero` no se puede leer: mensaje de error que incluya su nombre, código **4**.
4. `nivel` no es `INFO`, `WARN` ni `ERROR` (escrito exactamente así): mensaje de error que incluya el valor, código **3**.

No olvides:
- Comprobación de argumentos y mensajes de error, en el orden correcto (3 puntos).
- Contar por servicio para el nivel correcto, con el formato y el orden exactos (4 puntos).
- Casos especiales: ninguna línea de ese nivel, líneas en blanco o raras, una palabra de nivel dentro del mensaje, empates (3 puntos).
