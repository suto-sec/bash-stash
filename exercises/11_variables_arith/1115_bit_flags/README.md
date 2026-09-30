# 1115 · Bit flags with $(( ))

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★☆☆ · **Commands:** $(( )), & | ^ << >>

The file `n.txt` contains an integer N between 0 and 15 (four bit flags: 1, 2, 4 and 8). Using
`$(( ))` and the bitwise operators (`& | ^ << >>`), print, one per line:

1. `yes`/`no`: whether bit **1** is set in N
2. `yes`/`no`: whether bit **2** is set in N
3. `yes`/`no`: whether bit **4** is set in N
4. `yes`/`no`: whether bit **8** is set in N
5. N shifted left by 1 (`N << 1`)
6. N shifted right by 1 (`N >> 1`)
7. N XORed with 15 (`N ^ 15`)

---
Write your solution in `answer.sh`, then run `check 1115`.  
To experiment with the same test files the checker uses: `play 1115`.
