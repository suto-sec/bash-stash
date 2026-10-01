Write `findext.sh EXT`. It prints the path (as `find` shows it, starting with `./`) of every **regular file**, at any depth below the **current directory**, whose name ends in `.EXT`: `findext.sh txt` lists the `.txt` files. The order does not matter and `x.TXT` does not match `txt`.

`find . -type f -name "*.$1"` does it.
