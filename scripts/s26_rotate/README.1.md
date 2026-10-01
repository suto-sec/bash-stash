Write `rotate.sh FILE`. It copies `FILE` to `FILE.1` (replacing it if it exists), then **empties** `FILE` (it stays as an empty file) and prints `Rotated FILE`.

`cp -- file file.1` and `: > file`.
