// The fast track: a short, ordered plan for the final stretch (see fast.js). The exam has a theory test (4 options, no material)
// and ONE bash script (VS Code + man + the allowed cheatsheet).
// Item = [kind, id, flag]: kind ex | sc | quiz | exam (theory practice exam) | sx (script practice exam) | note (plain text tip, flag = its text).
// flag 'x' = an extra added for the plan, 'o' = optional (only if ahead): neither counts in `mins`, the planned time of the block.
// `mins` assumes a script takes about twice its nominal time, a theory question 40 s (easy) to 70 s (medium), and a review after every set.
// Left out on purpose: easy theory sets, tiers 3+, compression, users/logs exercises, the script ladders that repeat an exercise of the path.
// tools/fast_check.js checks that every id exists.
'use strict';
const FAST_DATA = [
  { id: 'b1', title: 'The exam-style script', mins: 75,
    why: '1801 has the shape of the exam script: an optional directory, argument checks with exit codes, find, a destination directory and a counter. Do it cold with only man and the cheatsheet, 25 minutes on the clock, then read the solution.',
    items: [['ex', '1801'],
            ['note', 'checklist', 'Write a checklist and keep it open: argument count, default directory, find -maxdepth/-type/-perm, quoting every variable, counters, exit codes, messages to stderr.'],
            ['note', 'gaps', 'The allowed cheatsheet does not list: $# $? $@, [[ ]], local, uniq, awk, printf, find -prune / -path / ! -name, and >> 2> (only on the redirections sheet). Know where to look: man bash (search /Special Parameters), man find, man uniq.']] },
  { id: 'b2', title: 'Classic file and text scripts', mins: 80,
    why: 'Same shape as the exam question: an optional directory, find, a little text processing. About 15 minutes each.',
    items: [['ex', '1803'], ['ex', '1804'], ['ex', '1805'], ['ex', '1806'], ['ex', '1807'], ['ex', '1808', 'o']] },
  { id: 'b3', title: 'find: selecting the right files', mins: 50,
    why: 'Choosing files is where script points are lost (ls parsing, recursion where it was not wanted). These train find with several tests, -exec, and acting on the result.',
    items: [['ex', '0740'], ['ex', '0743'], ['ex', '0744'], ['ex', '0745'], ['ex', '0747'], ['ex', '0746', 'o']] },
  { id: 'b4', title: 'Rehearsal 1 (timed)', mins: 80,
    why: 'A whole script graded like the exam: 25 minutes on the clock, no hints. Then 30 minutes of review: every new mistake goes into the checklist.',
    items: [['sx', 'medium-01']] },
  { id: 'b5', title: 'Theory: redirection', mins: 40,
    why: 'Redirection is where the test hides its traps. Single-choice thinking: read the 4 options, rule out three. The traps quiz is the recommended extra: it targets quoting, redirection and exit statuses.',
    items: [['quiz', '09_redirection'], ['quiz', '15_script_traps', 'x']] },

  { id: 'b6', title: 'Variants of the script, and functions', mins: 80,
    why: 'The same skeleton with another verb (options, a backup), then the function basics: the arguments of a function are not the script arguments. If an earlier script failed, redo it from a blank file first.',
    items: [['ex', '1820'], ['ex', '1810'], ['ex', '1601'], ['ex', '1602'], ['ex', '1604'], ['ex', '1605'],
            ['ex', '1811', 'o'], ['ex', '1606', 'o'], ['ex', '1802', 'o']] },
  { id: 'b7', title: 'Rehearsal 2 (timed)', mins: 100,
    why: 'The hard script exam: 35 minutes on the clock, then 30 minutes of review against the checklist.',
    items: [['sx', 'hard-01']] },
  { id: 'b8', title: 'Rehearsal 3 (extra)', mins: 0,
    why: 'Extra, not in the time plan: a fresh script of the same shape (copy the files that match a filter, create the destination, count). Only if rehearsal 2 went well.',
    items: [['sx', 'medium-02', 'x']] },
  { id: 'b9', title: 'Theory: processes and the medium sets', mins: 130,
    why: 'After every set write why each wrong option was wrong: the same distractors come back (quotes, > vs >>, 2>&1 order, && vs ;). The two quizzes and medium-06 are for when you are ahead.',
    items: [['quiz', '02_processes'], ['exam', 'medium-03'], ['exam', 'medium-04'], ['exam', 'medium-05'],
            ['exam', 'medium-06', 'o'], ['quiz', '07_find', 'o'], ['quiz', '11_scripting_logic', 'o']] },
  { id: 'b10', title: 'A hard set under exam conditions', mins: 25,
    why: 'No notes, no looking anything up: one hard set to see what the worst case feels like.',
    items: [['exam', 'hard-01']] },

  { id: 'b11', title: 'Final review', mins: 150,
    why: 'Nothing new. Warm up the script, redo what you missed and skim the cheatsheet. The dashed script exam is an optional extra (log processing instead of file copying).',
    items: [['note', 'retype', 'Retype 1801 from a blank file in 20 minutes.'],
            ['note', 'misses', 'Open the review of your medium and hard attempts and redo only the questions you missed.'],
            ['note', 'sheet', 'Skim the allowed cheatsheet once, only to know where things are.'],
            ['sx', 'medium-03', 'x']] },
];
