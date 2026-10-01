# 0722 · Which files contain a word

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -exec grep -l {} +, grep -L

Under `etc` there are configuration files. Print, separated by `---`:

1. the regular files ending in `.conf` that contain the word `debug` as a **whole word**, in **any
   case** (`debug`, `DEBUG`, `Debug`...), sorted. `debugging` or `log_debug` are not the word `debug`.
2. the regular `.conf` files that do **not** contain it, sorted.

Use `find ... -exec grep ... {} +` (one grep for many files) with the options that make grep print
only the **names** of the files that match (`-l`) or don't match (`-L`). Some names have spaces.
