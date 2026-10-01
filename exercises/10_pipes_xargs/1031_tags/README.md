# 1031 · tags.sh (tags of markdown notes)

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★★☆ · **Commands:** grep -h, sed, tr, sort | uniq -c, grep -l

Write `tags.sh`:

```
tags.sh DIR [TAG]
```

Under `DIR` (recursively) there are notes: regular files whose name ends in `.md`. A note may contain
**one** line that starts with `tags:` followed by a comma-separated list of tags, with optional spaces
around them, e.g. `tags: linux,  shell ,bash`. A tag is made of lowercase letters, digits and `-`, and
never appears twice in the same line. Other files and other lines (even if they contain tag names) are
ignored.

- **Without `TAG`**: print every tag with the number of notes that have it, as `<tag> (<count>)`,
  most used first, ties by tag in alphabetical order. Finish with
  `<T> distinct tags in <F> tagged notes` (`F` = notes that have a `tags:` line).
- **With `TAG`**: print the paths (as `find DIR` prints them, sorted) of the notes that have exactly
  that tag (`shell` does not match `shell-script`), then `<N> notes tagged <TAG>`. If no note has
  it: message on **stderr** and exit **4** (nothing on stdout).

Validation, in this order (message on **stderr**):

- no arguments or more than 2: usage, exit **1**
- `DIR` is not a directory: exit **2**
- `TAG` is not made only of lowercase letters, digits and `-`: exit **3**

Names may contain spaces.
