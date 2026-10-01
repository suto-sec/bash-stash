# 0227 · cd: relative, absolute and -

**Topic:** Directories & navigation · **Difficulty:** ★☆☆☆☆ · **Commands:** cd

The current directory contains a directory `a`, and inside it another one called `b`.

1. Use `cd` with a **relative** path (it does not start with `/`) to enter `a/b`, then print where you are with `pwd`.
2. Use `cd` with an **absolute** path (it starts with `/`) to go to `/usr`, then print `pwd`.
3. Go back to the previous directory with `cd -`. This command prints the directory itself, so you do not need `pwd`.

Expected output (the first and the third line depend on where the exercise runs):

```
/.../work/a/b
/usr
/.../work/a/b
```

Hint: `cd -` returns to the directory you were in before the last `cd`.

---
Write your solution in `answer.sh`, then run `check 0227`.  
To experiment with the same test files the checker uses: `play 0227`.
