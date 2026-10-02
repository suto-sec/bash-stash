# 2012 · Copy only what is newer

**Topic:** Man page tasks · **Difficulty:** ★★★☆☆ · **Commands:** cp

The folder `origen` has files and the folder `destino` has older or newer copies of some of them (plus files that only exist there).

Copy the files of `origen` into `destino` **but never replace a file of `destino` that is newer than the one in `origen`**. A file that is missing in `destino` is copied; an older one is replaced.

Use one `cp` command: it has an option for exactly this. Look in `man cp`.
