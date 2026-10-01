# 1106 · unset and default values

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★☆☆☆ · **Commands:** unset, ${VAR:-def}, ${VAR:=def}, ${VAR:?}

1. `COLOR=azul`; print `color: $COLOR`.
2. `unset COLOR`; print `color: ${COLOR:-negro}` (default only for printing).
3. Print `color: $COLOR` (still empty).
4. Use `${COLOR:=rojo}` so the default is also **assigned**, print it, and print `$COLOR` again (both lines as `color: ...`, like in steps 1-3).
5. Print the length of `$HOME` with `${#HOME}`.
