Write `organize.sh DIR`. Every **regular file directly inside** `DIR` is moved into a subdirectory of `DIR` named like its **extension** (what follows the **last** dot: `a.txt` goes to `DIR/txt/`, `archive.tar.gz` to `DIR/gz/`). Create the subdirectories as needed. Files without a dot and hidden files (names starting with a dot) are left where they are. Subdirectories are never touched. Assume no destination file exists yet in this step.

`ext=${name##*.}` is the extension (equal to the whole name when there is no dot).
