# 0915 · Reading two files in parallel

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★☆☆ · **Commands:** while read <&3, done 3< f1 4< f2, read -u

`nombres.txt` contains names (possibly with spaces) and `notas.txt` the grade of each one (an integer
0-10), line by line: line N of one file goes with line N of the other. Both have the same number of
lines. **Without `paste`**, read both files at the same time in one loop, using two extra file
descriptors (`done 3< nombres.txt 4< notas.txt` and `read ... <&3`, or `read -u 3`), and print for
each pair

```
<name>: <grade> PASS        (grade >= 5)
<name>: <grade> FAIL        (otherwise)
```

and finally `passed: <P>/<T>`.
