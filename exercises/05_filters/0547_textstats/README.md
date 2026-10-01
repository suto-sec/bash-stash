# 0547 · textstats.sh (a wc report, sorted)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** wc -l -w -c -L, sort -t -k, cut

Write `textstats.sh`:

```
textstats.sh FILE...
```

For every argument that is a readable regular file, compute its lines, words, bytes and the length
of its longest line (`wc -L`). Print one line per file:

```
<name>: <L> lines, <W> words, <B> bytes, longest <X>
```

sorted by **words descending** (numeric) and, for equal word counts, by **name** (the argument as
given, in `sort` order). Then print the summary:

```
TOTAL: <F> files, <L> lines, <W> words, <B> bytes
```

Arguments that are not readable regular files are skipped with a message on **stderr** that
includes the name (the report is still printed). Names may contain spaces.

Exit code: **1** (with usage on stderr) if there are no arguments; **2** if some argument was
skipped; **0** otherwise.
