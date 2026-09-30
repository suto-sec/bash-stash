# 1033 · grepall.sh (lines with all the words)

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★★☆ · **Commands:** grep -n -i -w, $( ), <<<, wc -l

Write `grepall.sh`:

```
grepall.sh FILE WORD...
```

Print the lines of `FILE` that contain **all** the given words, as **whole words** and ignoring case
(`grep -i -w`), in file order, each preceded by its line number: `<n>:<line>` (as `grep -n` prints
it). Finish with

```
<M> of <T> lines contain all <K> words
```

(`T` = lines of the file, `K` = number of words). Exit code **0** if at least one line matched; if
none did, print the summary anyway and exit with **4** (nothing on stderr).

Validation, in this order (message on **stderr**):

- fewer than 2 arguments: usage, exit **1**
- `FILE` is not a readable regular file: exit **2**
- a `WORD` is not made only of letters (a-z, A-Z): exit **3**, naming the first bad word

Hint: filter successively, keeping the result in a variable: `R=$(grep -in -w "$w" <<< "$R")`...
or chain `grep`s in a pipeline.

---
Write your solution in `answer.sh`, then run `check 1033`.  
To experiment with the same test files the checker uses: `play 1033`.
