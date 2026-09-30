# 1025 · Sales report with pipelines

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** tail -n +2, sort -t -k, cut, uniq -c, sed

`ventas.csv` has a header line `product,region,units` and then one sale per line. Using only
pipelines (no loops), print:

1. the **3** sales with the most units, most units first (ties: product alphabetically), as
   `<product> <units>`
2. a line `---`
3. every region with its number of sales (lines), sorted by region name, as `<region>: <count>`
4. a line `---`
5. the number of **distinct** products

---
Write your solution in `answer.sh`, then run `check 1025`.  
To experiment with the same test files the checker uses: `play 1025`.
