# 0806 · A strange umask

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** umask, chmod

Set the umask so that new directories get:

- owner: **only read**
- group: **only execute**
- others: read, write and execute

Then:

1. create directory `nuevodir` and file `nuevofichero_fuera` (see which permissions the file gets!)
2. add **a single permission** to `nuevodir` so the owner can **enter** it
3. add **a single permission** to `nuevodir` so the owner can **create files** in it
4. create `nuevodir/nuevofichero`
5. add **a single permission** to `nuevodir/nuevofichero` so the owner can write to it, then write
   the line `hola` into it

Nothing is printed.

---
Write your solution in `answer.sh`, then run `check 0806`.  
To experiment with the same test files the checker uses: `play 0806`.
