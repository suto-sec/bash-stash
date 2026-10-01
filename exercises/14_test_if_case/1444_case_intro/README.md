# 1444 · Quick refresher: case

**Topic:** test, if & case · **Difficulty:** ★☆☆☆☆ · **Commands:** case

`case` compares a value with several patterns and runs the commands of the first pattern that matches. `|` inside a pattern means "or" and `*` matches anything (use it as the last, default one).

The script receives a day abbreviation: `mon`, `tue`, `wed`, `thu`, `fri`, `sat` or `sun`. Print `weekend` for `sat` and `sun`, and `weekday` for the others, using a `case` statement.

Examples: `mon` prints `weekday`, `sat` prints `weekend`.

Hint:

```
case $1 in
  sat|sun) echo ... ;;
  *) echo ... ;;
esac
```

---
Write your solution in `answer.sh`, then run `check 1444`.  
To experiment with the same test files the checker uses: `play 1444`.
