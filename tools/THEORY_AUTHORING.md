# Authoring theory quizzes

Theory collections are plain-text sources in `tools/theory/*.txt` (one file per collection).
`node tools/build_theory.js` validates them and writes `theory/<collection>.json`, which the web UI
serves (`/api/theory`). Both the sources and the generated JSON are committed, like exercises.

```
node tools/build_theory.js               # build + validate everything
node tools/build_theory.js tools/theory/01_shell.txt
```

The compiler refuses to write anything while a question has a problem, and prints `file:line`.

## Format

```
@@collection 01_shell | Shell basics          first line; the id is used in URLs and progress files
@@about                                        optional text for the home-page card
One or two sentences.

@@group Getting help                           sidebar sub-category
@@q single | Short title                       type: single | multi | fill | order | match | sort
Question text in markdown (code blocks allowed).
(+) right option :: why it is right
(-) wrong option :: why it is wrong
@@note
Optional takeaway shown after answering.
```

`@@q <type> [custom-id] | title`: the id defaults to a slug of the title and is what progress is stored
under, so don't retitle a question that people may already have answered (or pin it with `[id]`).

| type | lines | grading |
|------|-------|---------|
| `single` | one `(+)`, two or more `(-)`; 3-7 options | the right one is picked |
| `multi` | two or more `(+)`, at least one `(-)` | exactly the right set is picked |
| `fill` | `{{answer ;; alternative}}` blanks in the text; `(x) wrong answer :: why not` lines; needs `@@note` | every blank equals an accepted answer (spaces collapsed, case sensitive) |
| `order` | `(>) step :: why it goes here`, written in the **correct** order (shown shuffled); 3-8 steps | every step in place |
| `match` | `(=) left => right :: why`; optional `(-) decoy :: why it matches nothing`; 3-8 pairs | every left has its right |
| `sort` | `@@buckets A \| B`; then `(A) item :: why`; 2-4 buckets, 4-10 items | every item in its bucket |

Rules that keep the quizzes useful:

- **Every option, step, pair and item needs an explanation** (`:: ...`), wrong ones included: say what
  the wrong option actually does, or where it would be right. A bare "wrong" teaches nothing.
- Options are shuffled on every attempt: never write "both of the above" or "a) and b)".
- Question text must not start a line with `(`.
- Write original wording; teach the concept, don't transcribe course material.
- Verify every claimed output by running it (the lab container is the reference environment).
