Write `diskuse.sh DIR`. For each **subdirectory directly inside** `DIR` (not files) print `NAME: SIZE`, where `SIZE` is the output of `du -sb` for it (bytes, including the contents). The order does not matter.

`du -sb path | cut -f1` gives just the number.
