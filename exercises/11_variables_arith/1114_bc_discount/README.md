# 1114 · Discounts with bc

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★☆☆ · **Commands:** bc, scale

The file `precios.txt` contains several prices (two decimals, e.g. `45.50`), one per line, and
`descuento.txt` contains a discount percentage (an integer). Using `bc` with the right `scale`, print,
in file order:

1. each price after applying the discount, with **2 decimals** (`price - price*discount/100`)
2. the total of all the discounted prices, with **2 decimals**
3. the total amount saved: the sum of the original prices minus the discounted total, with **2 decimals**

---
Write your solution in `answer.sh`, then run `check 1114`.  
To experiment with the same test files the checker uses: `play 1114`.
