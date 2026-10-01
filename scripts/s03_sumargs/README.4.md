Negative integers (`-5`) are now valid numbers. Print three lines, in this order:

```
Count: 3
Total: 10
Average: 3
```

The average is the integer division of the total by the count (`$(( total / count ))` truncates toward zero). Errors work as before (the bad-argument check must now accept an optional minus sign).
