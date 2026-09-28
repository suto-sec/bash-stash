# 1105 · Exported vs local variables

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★☆☆☆ · **Commands:** export, bash -c

1. Create the variable `LOCAL_VAR=uno` (not exported) and `GLOBAL_VAR=dos` (exported).
2. Run a child shell: `bash -c 'echo "local=[$LOCAL_VAR] global=[$GLOBAL_VAR]"'`
3. Print `printenv GLOBAL_VAR` and the exit code of `printenv LOCAL_VAR` (hide its output).
4. Export `LOCAL_VAR` too and run the child shell of step 2 again.

---
Write your solution in `answer.sh`, then run `check 1105`.  
To experiment with the same test files the checker uses: `play 1105`.
