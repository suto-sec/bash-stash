# 1125 · checksum.sh (manual decimal-to-binary)

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★★☆ · **Commands:** $(( )), %, printf %02x

Write `checksum.sh FILE`. `FILE` has one integer per line; a **valid byte** is an integer 0-255. Blank
lines are skipped silently.

Compute, over every valid byte (in file order): `N` = how many, `SUM` = their plain sum (`$(( ))`,
not modulo), and `CHK = SUM % 256`. Print:

```
Bytes: N
Sum: SUM
Checksum (dec): CHK
Checksum (hex): HEX
Checksum (bin): BIN
```

`HEX` is `CHK` in 2-digit lowercase hexadecimal (`printf '%02x'`). `BIN` is `CHK` written as an
**8-bit** binary string, computed with a loop and `$(( ))` (division and `%` by 2) — not with `bc`.

- not exactly 1 argument: usage on stderr, exit **1**
- `FILE` not readable: stderr, exit **2**
- no valid byte at all in `FILE`: stderr, exit **3**
- a non-blank line that isn't an integer 0-255 is skipped: print `Error: line L: <line>` on stderr and
  keep going; if this happened at least once, exit **4** at the end (only when there was no other
  error)
