# 0620 · Counting lines vs. occurrences

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -c, grep -o, grep -w -i, wc -l, uniq -c

`grep -c` counts **lines**, not occurrences. For the **whole word** `kernel` in **any case**
(`Kernel`, `KERNEL`... count; `kernels` or `kernel_x` don't; `kernel-x` does, as for `grep -w`)
in `texto.txt`, print exactly:

```
lines: <number of lines that contain it>
occurrences: <total number of occurrences in the file>
max: <largest number of occurrences in a single line>
```

If it never appears, all three numbers are `0`.

---
Write your solution in `answer.sh`, then run `check 0620`.  
To experiment with the same test files the checker uses: `play 0620`.
