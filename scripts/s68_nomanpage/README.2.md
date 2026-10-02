Checks, in this order:

- not exactly two arguments → an error message **and the correct usage** (e.g. `Usage: nomanpage.sh bindir mandir`) and exit **1**;
- `BINDIR` or `MANDIR` does not exist → an error message with its name and exit **2** (check `BINDIR` first);
- `BINDIR` or `MANDIR` exists but is not a directory → an error message with its name and exit **3** (again `BINDIR` first).

Everything else stays as before.
