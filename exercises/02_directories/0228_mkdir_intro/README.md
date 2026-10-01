# 0228 · mkdir and mkdir -p

**Topic:** Directories & navigation · **Difficulty:** ★☆☆☆☆ · **Commands:** mkdir, mkdir -p

`mkdir` creates a directory. With `-p` it also creates the parent directories that are missing.

1. Create the directory `datos`.
2. Create the nested path `proyecto/src/lib` with **one** `mkdir -p` command (`proyecto` and `src` do not exist yet).

Nothing is printed. Afterwards `ls -R proyecto` should show `src` and `lib`.

Hint: `mkdir -p one/two/three`

---
Write your solution in `answer.sh`, then run `check 0228`.  
To experiment with the same test files the checker uses: `play 0228`.
