# 1606 · Error helper functions

**Topic:** Functions · **Difficulty:** ★★☆☆☆ · **Commands:** function, >&2, exit

Write a helper `die CODE MESSAGE...` that prints `ERROR: MESSAGE` on **stderr** and exits the
**script** with CODE. Use it to validate the script's single argument (installed as `leer.sh`):

- no argument: `die 1 "usage: leer.sh FILE"`
- file doesn't exist: `die 2 "FILE not found"` (with the real name)
- not readable: `die 3 "FILE not readable"`
- otherwise print the number of words of the file (just the number)
