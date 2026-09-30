# 0720 · Regular expressions on names (-regex)

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -regextype posix-extended -regex

Under `camera`, print, separated by `---`:

1. the **regular files** whose **name** is exactly `IMG_` followed by **exactly 4 digits** and the
   extension `.jpg` or `.jpeg` (lowercase), sorted. `IMG_123.jpg`, `IMG_12345.jpg`, `img_1234.jpg`,
   `IMG_1234.JPG` or `IMG_1234.jpg.bak` don't count.
2. the regular files whose **name** contains a date `YYYY-MM-DD` (4 digits, `-`, 2 digits, `-`,
   2 digits) anywhere, sorted. A date in a **directory** name doesn't count.

Remember that `-regex` matches against the **whole path** (e.g. `camera/misc/IMG_1234.jpg`), not the
name, and it must match it entirely. `-regextype posix-extended` lets you use `{4}`, `?`, `+`...

---
Write your solution in `answer.sh`, then run `check 0720`.  
To experiment with the same test files the checker uses: `play 0720`.
