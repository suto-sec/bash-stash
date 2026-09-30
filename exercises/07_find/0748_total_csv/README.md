# 0748 · total_csv.sh: -exec {} + and the wc total line

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -exec {} +, wc -l, script argument

Write `total_csv.sh`:

```
total_csv.sh [directory]
```

Prints a single number: the total number of lines across every regular file ending in `.csv` under
`directory` (default: the current directory, searched recursively). If there are no matching files,
print `0`.

Hint: batch all the matches into **one** invocation of `wc -l` with `-exec ... {} +` (not
`{} \;`) — `wc` only prints an extra `total` line when it is given **more than one** file at once;
give it the files one at a time with `{} \;` and you never get that combined total, so you would
have to add the numbers up yourself instead.

---
Write your solution in `answer.sh`, then run `check 0748`.  
To experiment with the same test files the checker uses: `play 0748`.
