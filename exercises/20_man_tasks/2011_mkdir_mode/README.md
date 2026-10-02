# 2011 · A private folder in one command

**Topic:** Man page tasks · **Difficulty:** ★★★☆☆ · **Commands:** mkdir

Create the folders `proyecto/privado/claves` in a **single `mkdir` command**, so that:

- the missing parents (`proyecto` and `proyecto/privado`) get the usual default permissions, and
- the last one, `claves`, has permissions `rwx------` (octal 700).

No `chmod` allowed. `mkdir` can create the parents and set the mode at once: see `man mkdir`.
