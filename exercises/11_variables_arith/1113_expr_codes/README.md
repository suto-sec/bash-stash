# 1113 · String surgery with expr

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★☆☆ · **Commands:** expr length, expr match, expr substr

The file `codigo.txt` contains one line: a product code made of some uppercase letters followed by
some digits (e.g. `AB1234`). Using only `expr` (`length`, `match`, `substr`), print, one per line:

1. the length of the code
2. the number of leading letters (`expr match CODE '[A-Z]*'`)
3. the letters (the leading part of the code)
4. the digits (the rest of the code)
