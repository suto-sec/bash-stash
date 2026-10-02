# 2003 · Every field but one

**Topic:** Man page tasks · **Difficulty:** ★★★☆☆ · **Commands:** cut

`personas.csv` has comma-separated records. Every record has the same number of fields, but that number changes from file to file (between 5 and 8).

Print every record **without its 3rd field**, still separated by commas.

Example: `ana,22,madrid,ingles,rojo` becomes `ana,22,ingles,rojo`.

Don't count the fields: GNU `cut` can select "everything except" a list of fields. Look for it in `man cut`.
