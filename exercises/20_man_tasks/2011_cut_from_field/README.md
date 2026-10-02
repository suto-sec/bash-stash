# 2011 · From a field to the end

**Topic:** Exam tasks with the manual · **Difficulty:** ★★☆☆☆ · **Commands:** cut

`personas.csv` has comma-separated records. Every record has the same number of fields, but that number changes from file to file (between 5 and 8).

Print every record **from its 3rd field to its last one**, still separated by commas.

Example: `ana,22,madrid,ingles,rojo` becomes `madrid,ingles,rojo`.

The list of fields of `cut -f` accepts ranges that are open on one end: see `man cut`.
