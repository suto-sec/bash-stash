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
- Make wrong options as long and as plausible as the right one: the compiler warns when the right answer of a single-choice question is much longer than all the wrong ones (students would guess by length).
- Options are shuffled on every attempt: never write "both of the above" or "a) and b)".
- Question text must not start a line with `(`.
- Write original wording; teach the concept, don't transcribe course material.
- Verify every claimed output by running it (the lab container is the reference environment).

## Translations

A translation lives in `tools/theory/<lang>/` (currently `es`) with the **same file name and the same
`@@collection` id** as the English file, and is compiled to `theory/<lang>/<id>.json`. It must mirror
the English file question by question: same groups in the same order, same number of questions per
group, same types, the right options in the same positions, the same number of blanks/steps/pairs/decoys,
and the items in the same buckets. The compiler checks all of this and copies the question ids from the
English file, so a learner's progress is shared between languages. Translate titles, text, options,
explanations, notes and bucket names; keep commands, options and code in backticks unchanged. A
collection without a translation falls back to English.

## Practice exams

Sets of 10 single-choice questions with their own compile rules (exactly 4 options, a topic per question, pinned "none of the other
options" answers `(+!)` / `(-!)`, a per-slot blueprint) live in `tools/theory/exams/`. See `EXAMS_AUTHORING.md`.
