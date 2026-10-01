# 0635 · badnames.sh (non-portable file names)

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** find, grep -q -E, basename --, while read, sort

Write `badnames.sh`:

```
badnames.sh [DIR]
```

It checks the names of **all** entries (files, directories...) under `DIR` (default `.`,
recursively; `DIR` itself is not checked). A **name** (the last component of the path) is
**portable** when it is made only of ASCII letters `A-Z a-z`, digits, `.`, `_` and `-`, and does
not start with `-`.

For every non-portable entry print `<path> (<kind>)`, where `path` is as `find DIR` prints it and
`kind` is `space` if the name contains a space, otherwise `dash` if it starts with `-`, otherwise
`chars`. Order: by path, as `find DIR | sort` gives them. Finally print the summary

```
<B> of <T> names are not portable
```

(`T` = entries checked). Exit code: 0 if all names are portable, **3** otherwise.

Errors (message on **stderr**): more than one argument → usage, exit **1**; `DIR` is not a
directory → exit **2** (mention it).
