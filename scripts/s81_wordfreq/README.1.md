Write `wordfreq.sh FILE`. A **word** is a maximal run of ASCII letters; everything else (spaces, digits, punctuation, apostrophes, hyphens) separates words, and case is ignored: `Three` and `THREE` are the same word `three`, `it's` is `it` and `s`, `four-five` is `four` and `five`. Print one line `WORD: COUNT` per different word, the **most frequent first**, equal counts in alphabetical order (as `sort` orders text).

`tr -cs 'A-Za-z' '\n'` splits the words, `tr 'A-Z' 'a-z'` lowers them.
