# 1510 · Interactive input: read -p

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★☆☆☆ · **Commands:** read -p, read -s, read -t

Ask the user (stdin) for their **name** and their **age** using `read -p "Name: " NAME` and
`read -p "Age: " AGE` (the prompt goes to stderr, the checker ignores it), and print:

- `Hello NAME, next year you will be AGE+1` if AGE is a number (AGE+1 computed: Ana, 33 gives `Hello Ana, next year you will be 34`)
- `Hello NAME, that is not an age` otherwise
