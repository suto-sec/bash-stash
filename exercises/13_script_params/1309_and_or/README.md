# 1309 · && and

**Topic:** Script parameters & exit codes · **Difficulty:** ★★☆☆☆ · **Commands:** &&, ||

The script receives a directory name. **Without `if`**, using only `&&` and `||`:

1. try `mkdir "$1"` (hide errors): print `created $1` on success or `could not create $1` on failure
2. `cd` into it and print `inside` (if that fails, print `cannot enter` and exit 1)
3. finally print the result of `pwd`

---
Write your solution in `answer.sh`, then run `check 1309`.  
To experiment with the same test files the checker uses: `play 1309`.
