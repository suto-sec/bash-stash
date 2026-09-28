# 1306 · Accessing the last and n-th argument

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** ${!#}, ${@: -1}, ${10}

Print, one per line:

1. the **last** argument (`${!#}` or `${@: -1}`)
2. the **tenth** argument if it exists (careful: `$10` is `$1` followed by `0`; use `${10}`),
   or `none`
3. all arguments **except** the first and the last one, in one line (`${@:2:$#-2}`), or an empty line
   if there are fewer than 3

The script always receives at least one argument.

---
Write your solution in `answer.sh`, then run `check 1306`.  
To experiment with the same test files the checker uses: `play 1306`.
