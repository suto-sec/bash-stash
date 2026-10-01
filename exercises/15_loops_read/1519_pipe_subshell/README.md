# 1519 · The pipe-subshell pitfall

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** while read, < <( ), grep -v

`pedidos.txt` contains orders, one per line: `ID CUSTOMER AMOUNT` (AMOUNT is an integer). It also has
comment lines (starting with `#`) and blank lines. This script always prints `orders: 0`:

```bash
n=0; total=0
grep -v '^#' pedidos.txt | while read -r id cliente importe; do
  n=$((n + 1)); total=$((total + importe))
done
echo "orders: $n"
```

The loop runs in a **subshell** (every part of a pipeline does), so its variables are lost when it
ends. Fix it (for example with `done < <(grep ...)`) so that the script prints:

```
orders: N
total: S
max: ID (AMOUNT)
```

- blank lines and comment lines are not orders
- `max` is the order with the biggest amount (the first one in the file if tied)

Keep a `while read` loop.
