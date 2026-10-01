# 1826 · Most frequent words in a file

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** tr -cs, sort, uniq -c, head

Write `topwords.sh FILE [N]` (N default 5) that finds the N most frequent words in `FILE`. A "word"
is a maximal run of letters (`a-zA-Z`); everything else (digits, punctuation, spaces) is a
separator, and case is ignored (words are compared and printed in **lowercase**).

Print one line `<word> <count>` per word, ordered by count **descending**, ties broken
**alphabetically** (ascending). If `FILE` has fewer than N distinct words, print all of them.
Finally print `Total distinct words: N` (the real number of distinct words, not the requested N).

Checks, in this order:
- wrong number of arguments (not 1 or 2), or a given `N` that is not a positive integer: usage on
  stderr, exit **1**.
- `FILE` is not a readable regular file: message on stderr (naming `FILE`), exit **2**.
