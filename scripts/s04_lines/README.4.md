If the **first** argument is `-w`, the script counts **words** instead of lines (`wc -w`) and prints `file: W`; the `total:` line then adds the words. Every other behaviour stays the same, and `-w` alone (no file after it) is the usage error with code 1.

An argument is an option only in first position: in `lines.sh a.txt -w` the `-w` is just a file name that does not exist.
