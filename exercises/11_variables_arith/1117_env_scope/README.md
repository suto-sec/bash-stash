# 1117 · env, export and printenv together

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★☆☆ · **Commands:** env, export, printenv, unset

1. Set `MODE=prod` (do **not** export it).
2. Run `env MODE=test printenv MODE`: this starts `printenv` with `MODE` **temporarily** overridden to
   `test`, without touching the current shell's `MODE`.
3. Print `echo "$MODE"` (still `prod`: `env VAR=x cmd` only changes the environment of `cmd`).
4. `export MODE`, then run `env printenv MODE` (no override this time): now `printenv` finds it because
   it is exported.
5. `unset MODE`, then print the exit code of `env printenv MODE` (hide its output): it must be
   non-zero, since `MODE` no longer exists.

---
Write your solution in `answer.sh`, then run `check 1117`.  
To experiment with the same test files the checker uses: `play 1117`.
