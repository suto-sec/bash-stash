# 0907 · Here strings

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★☆☆☆ · **Commands:** <<<

The file `frase.txt` contains one line. Store it in a variable and then, **using here strings**
(`<<<`) and no pipes:

1. print the number of words of the line (`wc -w`)
2. print it in uppercase (`tr`)
3. read its first two words into variables `A` and `B` with `read A B REST <<< "$LINE"` and print `B A`
