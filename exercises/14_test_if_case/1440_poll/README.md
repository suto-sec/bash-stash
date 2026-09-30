# 1440 · poll.sh: tallying votes read from stdin

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** read, case, while

Read lines from standard input, one **vote** per line (`si`, `no` or anything else, which counts as
`invalido`, case-insensitive for `si`/`no`), until end of input. For each line print `voto: RESULT`
(RESULT being `si`, `no` or `invalido`). At the end print:

```
si: S
no: N
invalido: I
```

and finally `ganador: si`, `ganador: no` or `empate` (comparing S vs N only; invalid votes never
decide the winner — a tie between S and N, even 0-0, is `empate`).

---
Write your solution in `answer.sh`, then run `check 1440`.  
To experiment with the same test files the checker uses: `play 1440`.
