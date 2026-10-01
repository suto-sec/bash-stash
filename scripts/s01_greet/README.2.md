Now `greet.sh` may receive one argument, the name: `greet.sh Ana` prints `Hello, Ana!`. Without an argument it still prints `Hello, world!`.

The first argument is `$1`. A name with spaces arrives as one argument when it is quoted: `greet.sh "Mary Ann"` prints `Hello, Mary Ann!`.
