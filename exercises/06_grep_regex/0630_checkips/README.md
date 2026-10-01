# 0630 · checkips.sh (validating IPv4 addresses)

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep -n -x -E, groups, alternatives, grep -c

Write `checkips.sh`:

```
checkips.sh FILE
```

`FILE` contains one candidate per line. A line is a **valid IPv4 address** when the whole line
(nothing before or after, not even spaces) is four numbers separated by `.`, each number between
`0` and `255` written **without leading zeros** (`0` is fine, `07` or `000` are not).

Print every valid line as `<line number>: <address>` (in file order), and then the summary

```
Valid: <V>, invalid: <I>
```

where `I` counts the non-empty lines that are not valid (empty lines are ignored).
Exit code: 0 if there is at least one valid address, **3** otherwise (the summary is still printed).

Errors (message on **stderr**): not exactly one argument → usage, exit **1**;
`FILE` is not a readable regular file → exit **2** (mention it).

Hint: build the regex of one number (`25[0-5]|2[0-4][0-9]|...`) in a variable and reuse it.
