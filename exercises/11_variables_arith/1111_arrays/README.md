# 1111 · Arrays (bash knowledge)

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★☆☆ · **Commands:** arr=( ), ${arr[@]}, ${#arr[@]}, ${arr[i]}

The file `frutas.txt` contains one fruit per line. Load it into an array with
`mapfile -t FRUTAS < frutas.txt` (or `FRUTAS=($(cat frutas.txt))`) and print:

1. the number of elements
2. the first and the last element, separated by a space (`${FRUTAS[-1]}`)
3. all elements in one line
4. each element with its index: `0: apple`, `1: pear`, ...
