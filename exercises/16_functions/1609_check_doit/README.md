# 1609 · The classic check/doit script

**Topic:** Functions · **Difficulty:** ★★★☆☆ · **Commands:** functions, test -s, cp, exit

Reproduce (and fix) this classic textbook script, installed as `copia.sh`:

- `check SRC DST`: if `DST` exists and is **not empty** (`-s`), print `Target file exists! Exiting!`
  on stderr and exit the script with **1**. If `SRC` doesn't exist, print `Source missing!` on stderr
  and exit **2**.
- `doit SRC DST`: copy SRC to DST and print `copied`.
- the script needs exactly 2 arguments (else print `usage: copia.sh SRC DST` on stderr, exit 3);
  calls `check` then `doit`, and exits 0. Quote everything: names may have spaces.
