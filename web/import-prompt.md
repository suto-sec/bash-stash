# Prompt: write a content pack for bash stash

You are going to write practice material for **bash stash**, a web app that trains for a university Linux / shell-scripting exam (bash, files, permissions, find, grep, pipes, scripts, processes, users, boot). The material is delivered as **one JSON file** (a "pack") that the user imports in the app (Home → Imported → choose file).

## What I want from you

1. Ask me (the user) for anything you need that is missing: the **topic**, the **kinds** (quiz and/or exam), how many questions, the difficulty. If I already told you, do not ask again.
2. Write the pack following the format below **exactly**.
3. Reply with **only the JSON**: no explanations before or after it, no Markdown headings. A single fenced block (```json … ```) or the bare JSON are both fine. The file will be saved as `<pack id>.json`.
4. Before replying, run the **checklist** at the end and fix what fails.

The app checks the file when it is imported and shows every problem with its place ("item 1 › group 2 › question 4: …"). Anything that does not follow the format is rejected, so follow it literally.

## Language and style

- English only. Use Markdown inline code with backticks for commands, options, paths, file names and variables: `` `grep -r` ``, `` `$HOME` ``. Do not use other Markdown (no headings, no lists, no tables) inside texts. A text may contain a newline (`\n`) when really needed.
- Teach the concept. Write original questions; do not copy exam papers or course material.
- **Every option, step, pair and item needs a `why`**: one or two sentences saying why it is right, or what the wrong one actually does / where it would be right. A bare "wrong" teaches nothing. Wrong options must be as long and as plausible as the right one (do not make the right answer the longest).
- Options are shuffled by the app on every attempt: never write "all of the above", "both a and b" or refer to options by letter or position.
- Verify every claim about a command's output or behaviour as you would by running it in a standard Linux bash (Ubuntu/Debian, GNU tools). Do not ask about things that differ between systems.

## The file

```json
{
  "format": "bash-stash-pack",
  "version": 1,
  "id": "my-pack",
  "title": "Short title of the pack",
  "description": "One or two sentences (optional).",
  "items": [ { "kind": "quiz", … }, { "kind": "exam", … } ]
}
```

- `id`: lowercase identifier, `a-z 0-9 -`, at most 40 characters. Importing a pack with the same `id` replaces the old one (the user is asked).
- `items`: 1 to 100. Every item has a `kind` (`quiz` or `exam`) and an `id` (same identifier rules; unique per kind inside the pack).
- Do not add other fields: they are ignored.

### Item kind `quiz`

A collection of questions grouped in sections. Graded in the browser with instant feedback.

```json
{ "kind": "quiz", "id": "redirection", "title": "Redirection and pipes", "about": "What this quiz covers (optional).",
  "groups": [ { "id": "basics", "title": "The basics", "questions": [ … ] } ] }
```

- 1 to 30 groups; each group 1 to 200 questions. Group and question `id`s are identifiers; **a question id must be unique in the whole quiz and must not change** once the quiz is in use (the learner's progress is stored under it). A group `id` must be unique in the quiz.
- Mix the formats. A good quiz has mostly `single`, some `multi`, `fill`, `order`, `match`, `sort`.

Every question has `type`, `id`, `title` (short, shown in lists), `text` (the question, up to 4000 characters) and optionally `note` (a sentence shown after answering; **required for `fill`**).

#### `single`: one right option (3 to 7 options)

```json
{ "type": "single", "id": "append-op", "title": "Appending", "text": "Which operator appends standard output to a file?",
  "note": "optional",
  "options": [
    { "t": "`>>`", "ok": true,  "why": "It opens the file for appending." },
    { "t": "`>`",  "ok": false, "why": "It truncates the file first." },
    { "t": "`<`",  "ok": false, "why": "It reads input from a file." } ] }
```
Exactly one option has `"ok": true`.

#### `multi`: several right options (3 to 8 options)

Same shape as `single`, but **at least two** options are `"ok": true` and **at least one** is `false`. The learner must select exactly the right set.

#### `fill`: blanks in a sentence

```json
{ "type": "fill", "id": "exit-codes", "title": "Exit status",
  "text": "After a successful command `$?` is `{{0}}`; the number of arguments is in `{{1}}`.",
  "note": "Required: one sentence that explains the idea.",
  "blanks": [ { "answers": ["0"] }, { "answers": ["$#"] } ],
  "wrong": [ { "a": "1", "why": "1 is a failure code, not the success code." } ] }
```
- `{{0}}`, `{{1}}`… mark the blanks in `text`; each number from 0 to (number of blanks − 1) must appear, and `blanks` has one entry per number (1 to 6).
- `answers`: every accepted spelling (1 to 8). Matching ignores extra spaces but is case sensitive. Prefer blanks with one obvious answer.
- `wrong` (optional but recommended): typical wrong answers with the reason they are wrong.

#### `order`: put the steps in order (3 to 8)

```json
{ "type": "order", "id": "run-script", "title": "Running a script", "text": "Put the steps in order.",
  "items": [ { "t": "Write the script", "why": "…" }, { "t": "Make it executable", "why": "…" }, { "t": "Run it", "why": "…" } ] }
```
Write the items **in the correct order**; the app shuffles them. Every step must be distinct.

#### `match`: pair left and right (3 to 8 pairs)

```json
{ "type": "match", "id": "streams", "title": "Standard streams", "text": "Match each stream with its number.",
  "pairs": [ { "l": "standard input", "r": "0", "why": "…" }, { "l": "standard output", "r": "1", "why": "…" }, { "l": "standard error", "r": "2", "why": "…" } ],
  "extras": [ { "r": "3", "why": "Not assigned to any of these." } ] }
```
Left sides must all differ and right sides must all differ. `extras` (optional, up to 4) are decoy right sides that match nothing.

#### `sort`: put items into buckets (2 to 4 buckets, 4 to 10 items)

```json
{ "type": "sort", "id": "builtin-or-not", "title": "Builtin or external", "text": "Classify each command.",
  "buckets": ["Builtin", "External program"],
  "items": [ { "t": "`cd`", "bucket": "Builtin", "why": "…" }, { "t": "`ls`", "bucket": "External program", "why": "…" } ] }
```
Every `bucket` of an item must be exactly one of `buckets`, and every bucket must get at least one item.

### Item kind `exam`

A mock exam: **exactly 10 questions, all `single`** (3 to 5 options each, exactly one right), 1 point each, no penalty, pass at 5/10.

```json
{ "kind": "exam", "id": "basics-1", "title": "Basics exam 1", "about": "Ten single-choice questions on … (optional).",
  "questions": [ { "type": "single", "id": "q1", … }, … 10 in total … ] }
```
Exam questions have the same fields as `single` above. One concept per question, classic look-alike options, mixed difficulty. Question ids unique inside the exam.

## Limits

Texts: question `text` and `note` up to 4000 characters; option, step, pair and item texts and `why` up to 1200; titles up to 200. At most 100 items per pack, 200 questions per quiz, and the file at most 3 MB.

## Checklist (run it before you reply)

- [ ] The reply is valid JSON (double quotes, no comments, no trailing commas, nothing outside the JSON).
- [ ] `format` is `"bash-stash-pack"`, `version` is `1`, every `id` follows the identifier rules and is unique where required.
- [ ] Every `single` has exactly one `ok: true`; every `multi` has at least two right and one wrong option.
- [ ] Every `fill` has a `note`, a `{{n}}` for each blank and one `blanks` entry per `{{n}}`.
- [ ] Every option / step / pair / item has a useful `why`.
- [ ] No option is the obvious winner by length; no "all of the above".
- [ ] Every exam has exactly 10 single-choice questions.
- [ ] Every command behaviour mentioned is correct on a standard GNU/Linux bash.
