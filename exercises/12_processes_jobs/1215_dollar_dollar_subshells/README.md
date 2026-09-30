# 1215 · $$ across command substitution and background subshells

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★☆☆ · **Commands:** $$, $BASHPID, $( ), ( ) &, wait

Print, on separate lines, only the word `same` or `different`:

1. Is `$$` read inside `$( ... )` (command substitution) equal to your script's own `$$`?
2. Is `$BASHPID` read inside that same `$( ... )` equal to your script's `$$`?
3. Is `$$` read inside `( ... ) &` (a background subshell) equal to your script's `$$`? (`wait` for it
   before checking; have the subshell write its `$$` to a file so you can read it back.)

Think about why: `$$` always names the **original** shell, even inside subshells; only `$BASHPID` (and
a real new process) changes.

---
Write your solution in `answer.sh`, then run `check 1215`.  
To experiment with the same test files the checker uses: `play 1215`.
