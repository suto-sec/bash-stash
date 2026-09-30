# 0113 · A receipt with printf

**Topic:** Echo, quoting & substitution · **Difficulty:** ★★★☆☆ · **Commands:** printf %s %d %02d %8s, read, $(( ))

The file `order.txt` contains one line with three fields separated by one space:
an item name, a quantity and a unit price **in cents** (e.g. `kernel 3 1250`).

Print this receipt with `printf` (the example is for `kernel 3 1250`):

```
Item      : kernel
Quantity  :        3
Unit price:    12.50 EUR
Total     :    37.50 EUR
```

- The labels are written exactly as shown (`Item` and `Total` are padded with spaces so that
  every `:` is in column 11).
- Quantity, unit price and total are **right-aligned in a field of 8 characters** after `: `.
- Prices are euros with **exactly two decimals** (`105` cents → `1.05`, `7` cents → `0.07`).
  Total = quantity × unit price.

Hint: `read NAME QTY PRICE < order.txt`; euros and cents are `$((P / 100))` and `$((P % 100))`,
and `%02d` pads with zeros.

---
Write your solution in `answer.sh`, then run `check 0113`.  
To experiment with the same test files the checker uses: `play 0113`.
