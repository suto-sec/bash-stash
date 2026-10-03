// bash stash web UI server (runs inside the lab container as alumno).
//   /                 single page app (web/public)
//   /api/...          exercises, checker, solutions, theme
//   /pty              websocket: a real bash terminal (node-pty)
//   /vscode/...       reverse proxy to code-server (VS Code in the browser)
'use strict';
const http = require('http');
const fs = require('fs');
const path = require('path');
const os = require('os');
const { spawn, execFileSync } = require('child_process');
const { WebSocketServer } = require('ws');
const pty = require('node-pty');
const httpProxy = require('http-proxy');
const zlib = require('zlib');

const LAB = process.env.LAB || '/home/alumno/lab';
const PORT = Number(process.env.PORT || 8080);
const CODE_SERVER = 'http://127.0.0.1:8081';
const VENDOR = process.env.VENDOR || '/opt/web/node_modules';
const PUBLIC = path.join(__dirname, 'public');
const PROGRESS = process.env.LAB_PROGRESS || path.join(LAB, '.progress');   // LAB_PROGRESS: scratch dir for tests
const CS_SETTINGS = path.join(process.env.HOME || '/home/alumno', '.local/share/code-server/User/settings.json');

// ------------------------------------------------------------------ exercises
function isAttempted(file) {
  try {
    return fs.readFileSync(file, 'utf8').split('\n').some(l => !/^\s*(#.*)?$/.test(l));
  } catch { return false; }
}

// Track tiers: which of the three authoring batches (tools/src/*.txt) an exercise came from —
// the base file (tier 1, closest to the course material's own examples), its "_exam" companion
// (tier 2, added specifically to mirror real exam patterns) or its "_more" companion (tier 3, the
// later bulk-expansion batch, furthest from the original teaching set). A base file's own name can
// itself end in "_exam" or "_more" (e.g. topic 18 is named "18_exam"), so a file only counts as a
// companion batch when a base file also exists under its name with that suffix stripped.
// tracks: minimal = tier 1, intermediate = tiers 1-2, complete = every tier (unfiltered = 'full').
function buildTierMap() {
  const dir = path.join(LAB, 'tools/src');
  const map = {};
  let files;
  try { files = fs.readdirSync(dir).filter(f => f.endsWith('.txt')); } catch { return map; }
  const fileSet = new Set(files);
  for (const f of files) {
    let tier = 1;
    // a file only counts as an "_exam"/"_more" companion batch when a DIFFERENT file exists under
    // its name with that suffix stripped — otherwise it's a base file whose own name happens to end
    // that way (e.g. topic 18 is named "18_exam", so "18_exam.txt" is ITS base file, and
    // "18_exam_more.txt" is correctly its "more" companion, not "18"'s).
    if (f.endsWith('_exam.txt')) {
      const base = f.slice(0, -9) + '.txt';
      if (base !== f && fileSet.has(base)) tier = 2;
    } else if (f.endsWith('_more.txt')) {
      const base = f.slice(0, -9) + '.txt';
      if (base !== f && fileSet.has(base)) tier = 3;
    } else if (f.endsWith('_intro.txt')) {
      // tier 0: tiny one-concept "Introduction" refreshers, reachable only via the per-category
      // picker on the home page — never part of any track (Minimal/Intermediate/Full all skip them)
      const base = f.slice(0, -10) + '.txt';
      if (base !== f && fileSet.has(base)) tier = 0;
    }
    if (/^20_/.test(f)) tier = 4;   // the man page tasks: only reachable from the Man drills section, never part of a track
    const content = fs.readFileSync(path.join(dir, f), 'utf8');
    for (const m of content.matchAll(/^@@ex (\d{4})\b/gm)) map[m[1]] = tier;
  }
  return map;
}
const TIER_MAP = buildTierMap();

// Older generated READMEs end with a footer telling the learner to run `check`/`play` in a terminal; the web UI has buttons for that.
const stripCliFooter = text => text.replace(/\n---\nWrite your (?:solution in `answer\.sh`|answers in `answer\.txt`[^\n]*)[\s\S]*$/, '\n');

function exerciseInfo(topicDir, name) {
  const dir = path.join(topicDir, name);
  const id = name.split('_')[0];
  const readme = fs.readFileSync(path.join(dir, 'README.md'), 'utf8');
  const lines = readme.split('\n');
  const title = lines[0].replace(/^#\s*\S+\s*·\s*/, '');
  const meta = lines.find(l => l.startsWith('**Topic:**')) || '';
  const level = (meta.match(/★/g) || []).length;
  const cmds = (meta.match(/\*\*Commands:\*\*\s*(.*)$/) || [, ''])[1];
  const quiz = fs.existsSync(path.join(dir, 'answer.txt'));
  const answer = path.join(dir, quiz ? 'answer.txt' : 'answer.sh');
  const tier = id in TIER_MAP ? TIER_MAP[id] : 1; // tier can legitimately be 0 — `||` would misfire on it
  let status = 'new';
  if (fs.existsSync(path.join(PROGRESS, id))) status = 'pass';
  else if (fs.existsSync(path.join(PROGRESS, id + '.viewed'))) status = 'viewed';
  else if (isAttempted(answer)) status = 'attempted';
  return { id, name, title, level, cmds, quiz, dir, answer, status, tier };
}

function index() {
  const root = path.join(LAB, 'exercises');
  return fs.readdirSync(root).filter(t => /^\d\d_/.test(t)).sort().map(t => {
    const topicDir = path.join(root, t);
    // a folder without its README is not an exercise (e.g. the leftover answer file of an exercise from another branch)
    const exercises = fs.readdirSync(topicDir).filter(e => /^\d{4}_/.test(e) && fs.existsSync(path.join(topicDir, e, 'README.md'))).sort()
      .map(e => exerciseInfo(topicDir, e));
    if (!exercises.length) return null;
    const first = fs.readFileSync(path.join(topicDir, exercises[0].name, 'README.md'), 'utf8');
    const title = (first.match(/\*\*Topic:\*\*\s*(.*?)\s*·/) || [, t])[1];
    return { id: t.slice(0, 2), dir: t, title, exercises };
  }).filter(Boolean);
}

function findExercise(id) {
  if (!/^\d{4}$/.test(id)) return null;
  for (const t of index()) for (const e of t.exercises) if (e.id === id) return { ...e, topic: t };
  return null;
}

function solutionFile(ex) {
  const base = path.join(LAB, 'solutions', ex.topic.dir, ex.name);
  return fs.existsSync(base + '.sh') ? base + '.sh' : base + '.txt';
}

// ------------------------------------------------------------------ imported packs
// A pack is one json file the user imported (web/importer.js validates it; web/import-prompt.md describes it). It is kept, normalized, in
// .progress/imported/<pack-id>/pack.json: personal data, git-ignored, never executed. Its quizzes and exams are served through the
// ordinary theory and exam APIs under the id "imp-<pack>-<item>", flagged `imp` so the pages keep them apart from the course material:
// they have their own progress and never count in the home totals, the suggested path or the readiness.
const importer = require('./importer');
const IMPORT_DIR = path.join(PROGRESS, 'imported');
function readPacks() {
  let ids = [];
  try { ids = fs.readdirSync(IMPORT_DIR).filter(n => importer.SLUG.test(n)); } catch { /* nothing imported */ }
  const out = [];
  for (const id of ids) {
    try {
      const pack = JSON.parse(fs.readFileSync(path.join(IMPORT_DIR, id, 'pack.json'), 'utf8'));
      if (pack && pack.id === id && Array.isArray(pack.items)) out.push(pack);
    } catch { /* a broken pack file is skipped */ }
  }
  return out.sort((a, b) => String(a.addedAt).localeCompare(String(b.addedAt)));
}
const impId = (pack, item) => `imp-${pack.id}-${item.id}`;
function impCollections() {
  return readPacks().flatMap(p => p.items.filter(i => i.kind === 'quiz').map(i =>
    ({ id: impId(p, i), title: i.title, about: i.about, groups: i.groups, imp: p.id, packTitle: p.title })));
}
function impExams() {
  return readPacks().flatMap(p => p.items.filter(i => i.kind === 'exam').map(i =>
    ({ id: impId(p, i), title: i.title, about: i.about, tier: 'imported', imp: p.id, packTitle: p.title,
       questions: i.questions.map(q => ({ ...q, topic: 'imported' })) })));
}
function writePack(pack) {
  const dir = path.join(IMPORT_DIR, pack.id);
  fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(path.join(dir, 'pack.json.tmp'), JSON.stringify(pack));
  fs.renameSync(path.join(dir, 'pack.json.tmp'), path.join(dir, 'pack.json'));
}
// what happened to the packs, newest last: { at, action: added | replaced | removed | renamed, pack, title, detail }
const HISTORY_FILE = path.join(IMPORT_DIR, 'history.json');
function readHistory() {
  try { const h = JSON.parse(fs.readFileSync(HISTORY_FILE, 'utf8')); return Array.isArray(h) ? h : []; } catch { return []; }
}
function logHistory(action, pack, detail) {
  const h = readHistory();
  h.push({ at: new Date().toISOString(), action, pack: pack.id, title: pack.title, detail: detail || '' });
  fs.mkdirSync(IMPORT_DIR, { recursive: true });
  fs.writeFileSync(HISTORY_FILE + '.tmp', JSON.stringify(h.slice(-500)));
  fs.renameSync(HISTORY_FILE + '.tmp', HISTORY_FILE);
}
const itemsLine = pack => { const q = pack.items.filter(i => i.kind === 'quiz').length, e = pack.items.filter(i => i.kind === 'exam').length; return [q && `${q} quiz${q === 1 ? '' : 'zes'}`, e && `${e} exam${e === 1 ? '' : 's'}`].filter(Boolean).join(', '); };
function deletePack(id, withProgress) {
  fs.rmSync(path.join(IMPORT_DIR, id), { recursive: true, force: true });
  if (!withProgress) return;
  for (const [dir, ext] of [[THEORY_PROGRESS, '.json'], [EXAM_PROGRESS, '.json'], [EXAM_PROGRESS, '.draft.json'], [SC_PROGRESS, '.steps']]) {
    try { for (const f of fs.readdirSync(dir)) if (f.startsWith(`imp-${id}-`) && f.endsWith(ext)) fs.unlinkSync(path.join(dir, f)); } catch { /* none */ }
  }
  try { for (const f of fs.readdirSync(SC_PROGRESS)) if (f.startsWith(`imp-${id}-`)) fs.rmSync(path.join(SC_PROGRESS, f), { recursive: true, force: true }); } catch { /* none */ }
  try { const play = path.join(process.env.HOME || '/home/alumno', 'play'); for (const f of fs.readdirSync(play)) if (f.startsWith(`imp-${id}-`)) fs.rmSync(path.join(play, f), { recursive: true, force: true }); } catch { /* none */ }
}
// the request body as text (a pack can be a few hundred KB), parsed here so a syntax error can be reported
function readRaw(req, max = 3e6) {
  return new Promise(resolve => {
    let b = '', over = false;
    req.on('data', c => { b += c; if (b.length > max) { over = true; req.destroy(); } });
    req.on('end', () => resolve(over ? { error: 'The file is too big (at most 3 MB).' } : { text: b }));
    req.on('error', () => resolve({ error: 'The upload was interrupted.' }));
  });
}

// ---- imported scripts: code. They are written (never run) as the same folders the course scripts have, under scripts/imp-<pack>-<item>_script
// and solutions/scripts/ (both git-ignored), so the whole scripts machinery works for them; the engine runs them only after the user allowed the
// pack, inside the sandbox (sandboxArgs), and a snapshot of the progress was taken first.
const crypto = require('crypto');
const scriptItems = pack => pack.items.filter(i => i.kind === 'script');
function packCode(pack) {          // every piece of code of a pack, as the user sees it and as the consent hash covers it
  return scriptItems(pack).map(i => ({ id: i.id, title: i.title, script: i.script, fixture: i.fixture,
    steps: i.steps.map(st => ({ n: st.n, title: st.title, check: st.check, solution: st.solution })) }));
}
const packCodeHash = pack => crypto.createHash('sha256').update(JSON.stringify(packCode(pack))).digest('hex');
const consentFile = id => path.join(IMPORT_DIR, id, 'consent.json');
function readConsent(id) { try { return JSON.parse(fs.readFileSync(consentFile(id), 'utf8')); } catch { return null; } }
function packConsented(id) {
  if (!importer.SLUG.test(id || '')) return false;
  const pack = readPacks().find(p => p.id === id);
  if (!pack) return false;
  if (!scriptItems(pack).length) return true;
  const c = readConsent(id);
  return !!c && c.hash === packCodeHash(pack);
}
const SNAP = id => path.join(IMPORT_DIR, id, 'snapshot.tar.gz');
function takeSnapshot(id) {
  // what a pack's code could touch: the progress and the answers. (the imported packs themselves are not part of it)
  const answers = [];
  const walkAns = d => { try { for (const n of fs.readdirSync(d)) { const f = path.join(d, n); const st = fs.statSync(f); if (st.isDirectory()) walkAns(f); else if (/^answer/.test(n)) answers.push(path.relative(LAB, f)); } } catch { /* none */ } };
  walkAns(path.join(LAB, 'exercises'));
  const list = path.join(IMPORT_DIR, id, 'snapshot.list');
  fs.mkdirSync(path.join(IMPORT_DIR, id), { recursive: true });
  const members = [];
  if (fs.existsSync(PROGRESS)) for (const n of fs.readdirSync(PROGRESS)) if (n !== 'imported') members.push(path.relative(LAB, path.join(PROGRESS, n)));
  fs.writeFileSync(list, [...members, ...answers].join('\n') + '\n');
  execFileSync('tar', ['-czf', SNAP(id), '-C', LAB, '-T', list], { stdio: 'ignore' });
  fs.unlinkSync(list);
}
function restoreSnapshot(id) {
  if (!fs.existsSync(SNAP(id))) return false;
  if (fs.existsSync(PROGRESS)) for (const n of fs.readdirSync(PROGRESS)) if (n !== 'imported') fs.rmSync(path.join(PROGRESS, n), { recursive: true, force: true });
  execFileSync('tar', ['-xzf', SNAP(id), '-C', LAB], { stdio: 'ignore' });
  return true;
}
function materialize(pack) {
  for (const it of scriptItems(pack)) {
    const id = `imp-${pack.id}-${it.id}`, name = `${id}_script`;
    const dir = path.join(LAB, 'scripts', name), sol = path.join(LAB, 'solutions/scripts', name);
    fs.rmSync(dir, { recursive: true, force: true }); fs.rmSync(sol, { recursive: true, force: true });
    fs.mkdirSync(dir, { recursive: true }); fs.mkdirSync(sol, { recursive: true });
    fs.writeFileSync(path.join(dir, 'meta.json'), JSON.stringify({ id, slug: 'script', title: it.title, script: it.script, cmds: it.cmds || '', level: it.level, tags: it.tags,
      steps: it.steps.map(st => ({ n: st.n, title: st.title })), imp: pack.id, packTitle: pack.title }, null, 1) + '\n');
    for (const st of it.steps) {
      fs.writeFileSync(path.join(dir, `README.${st.n}.md`), st.readme.trim() + '\n');
      fs.writeFileSync(path.join(dir, `check.${st.n}.sh`), `# checker spec for ${id} step ${st.n} (imported; see lib/engine.sh)\nSCRIPT_NAME=${it.script}\n${(it.fixture || '').trim()}\n${st.check.trim()}\n`);
      fs.writeFileSync(path.join(sol, `${st.n}.sh`), st.solution.trim() + '\n', { mode: 0o755 });
    }
  }
}
function syncMaterialized() {        // the folders of the imported scripts follow the packs: written for the existing ones, removed for the others
  const want = new Set(readPacks().flatMap(p => scriptItems(p).map(i => `imp-${p.id}-${i.id}_script`)));
  for (const base of [path.join(LAB, 'scripts'), path.join(LAB, 'solutions/scripts')]) {
    try { for (const n of fs.readdirSync(base)) if (n.startsWith('imp-') && !want.has(n)) fs.rmSync(path.join(base, n), { recursive: true, force: true }); } catch { /* none */ }
  }
  for (const p of readPacks()) materialize(p);
}
function packStatus(p) {
  const code = scriptItems(p).length > 0, c = code ? readConsent(p.id) : null;
  return { code, consented: code ? packConsented(p.id) : null, consentAt: c && c.hash === packCodeHash(p) ? c.at : null, snapshotAt: code && fs.existsSync(SNAP(p.id)) ? fs.statSync(SNAP(p.id)).mtime.toISOString() : null };
}

// ------------------------------------------------------------------ theory quizzes
// Collections are compiled from tools/theory/*.txt into theory/<id>.json (tools/build_theory.js).
// They are a parallel track to the exercises: graded in the browser (instant feedback), only the
// per-question result is stored here: .progress/theory/<collection>.json  {qid: {pass, tries}}.
// Translations live in theory/<lang>/<id>.json with the same question ids, so progress is shared
// across languages; a collection without a translation falls back to English.
const THEORY = path.join(LAB, 'theory');
const THEORY_PROGRESS = path.join(PROGRESS, 'theory');
const SAFE_ID = /^[\w-]+$/;

const THEORY_LANGS = ['es'];
function loadCollection(id, lang) {
  if (!SAFE_ID.test(id)) return null;
  if (id.startsWith('imp-')) return impCollections().find(c => c.id === id) || null;
  const dirs = THEORY_LANGS.includes(lang) ? [path.join(THEORY, lang), THEORY] : [THEORY];
  for (const d of dirs) {
    try { return JSON.parse(fs.readFileSync(path.join(d, id + '.json'), 'utf8')); } catch { /* try the next */ }
  }
  return null;
}
function theoryProgress(cid) {
  try { return JSON.parse(fs.readFileSync(path.join(THEORY_PROGRESS, cid + '.json'), 'utf8')); } catch { return {}; }
}
function questionStatus(p) { return !p ? 'new' : p.pass ? 'pass' : 'attempted'; }
function theoryIndex(lang) {
  let files = [];
  try { files = fs.readdirSync(THEORY).filter(f => f.endsWith('.json')).sort(); } catch { /* no theory yet */ }
  return [...files.map(f => loadCollection(f.slice(0, -5), lang)).filter(Boolean), ...impCollections()].map(c => {
    const prog = theoryProgress(c.id);
    return { id: c.id, title: c.title, about: c.about, ws: !!c.ws, imp: c.imp, packTitle: c.packTitle, groups: c.groups.map(g => ({
      id: g.id, title: g.title,
      questions: g.questions.map(q => ({ id: q.id, title: q.title, type: q.type, status: questionStatus(prog[q.id]) })),
    })) };
  });
}
function writeTheoryProgress(cid, prog) {
  fs.mkdirSync(THEORY_PROGRESS, { recursive: true });
  const file = path.join(THEORY_PROGRESS, cid + '.json');
  fs.writeFileSync(file + '.tmp', JSON.stringify(prog));
  fs.renameSync(file + '.tmp', file);
}

// ------------------------------------------------------------------ practice exams
// Sets of 10 single-choice questions compiled from tools/theory/exams/*.txt into theory/exams/<id>.json
// (translations in theory/exams/<lang>/, same question ids and option order). They are graded here: the
// browser sends which option (index in the source order) was picked for each question, the server
// recomputes the score from the answer key and stores every finished attempt in
// .progress/exams/<id>.json (an array, oldest first). Exams do not touch the theory-question progress.
const EXAMS = path.join(THEORY, 'exams');
const EXAM_PROGRESS = path.join(PROGRESS, 'exams');
const EXAM_PASS = 5;            // pass line, out of 10
const EXAM_MAX_ATTEMPTS = 200;  // kept per set (oldest dropped)
const EXAM_TIER_ORDER = ['easy', 'medium', 'hard'];
function loadExam(id, lang) {
  if (!SAFE_ID.test(id)) return null;
  if (id.startsWith('imp-')) return impExams().find(e => e.id === id) || null;
  const dirs = THEORY_LANGS.includes(lang) ? [path.join(EXAMS, lang), EXAMS] : [EXAMS];
  for (const d of dirs) {
    try { return JSON.parse(fs.readFileSync(path.join(d, id + '.json'), 'utf8')); } catch { /* try the next */ }
  }
  return null;
}
function examAttempts(id) {
  try { const a = JSON.parse(fs.readFileSync(path.join(EXAM_PROGRESS, id + '.json'), 'utf8')); return Array.isArray(a) ? a : []; }
  catch { return []; }
}
// Per exam topic: how many questions have been answered in the theory practice exams and how many were right (the LAST answer to each
// question counts), the exam share of each topic (tools/theory/exams/blueprint.json) and the questions answered wrongly most recently.
function examStats() {
  let ids = [];
  try { ids = fs.readdirSync(EXAMS).filter(f => f.endsWith('.json')).map(f => f.slice(0, -5)); } catch { /* no exams yet */ }
  const topics = {}, missed = [];
  let attempts = 0;
  for (const id of ids) {
    const exam = loadExam(id), at = examAttempts(id);
    if (!exam || !at.length) continue;
    attempts += at.length;
    const last = new Map();
    for (const a of at) for (const r of a.answers || []) last.set(r.q, { ok: !!r.ok, n: a.n, at: a.finishedAt, answered: r.pick !== null && r.pick !== undefined });
    for (const q of exam.questions) {
      const r = last.get(q.id);
      if (!r || !r.answered) continue;
      const t = topics[q.topic] = topics[q.topic] || { answered: 0, correct: 0 };
      t.answered++; if (r.ok) t.correct++; else missed.push({ exam: id, attempt: r.n, qid: q.id, title: q.title, topic: q.topic, at: r.at });
    }
  }
  let weights = {};
  try { const quota = JSON.parse(fs.readFileSync(path.join(LAB, 'tools/theory/exams/blueprint.json'), 'utf8')).topicQuota, sum = Object.values(quota).reduce((x, y) => x + y, 0); for (const [k, v] of Object.entries(quota)) weights[k] = v / sum; } catch { /* no blueprint: the page weighs every topic equally */ }
  missed.sort((a, b) => String(b.at).localeCompare(String(a.at)));
  return { weights, topics, missed: missed.slice(0, 40), attempts };
}
function writeExamAttempts(id, list) {
  fs.mkdirSync(EXAM_PROGRESS, { recursive: true });
  const file = path.join(EXAM_PROGRESS, id + '.json');
  fs.writeFileSync(file + '.tmp', JSON.stringify(list));
  fs.renameSync(file + '.tmp', file);
}
// An attempt in progress is kept (one per set) in .progress/exams/<id>.draft.json so it can be resumed or discarded.
const draftFile = id => path.join(EXAM_PROGRESS, id + '.draft.json');
function readDraft(exam) {
  try {
    const d = JSON.parse(fs.readFileSync(draftFile(exam.id), 'utf8'));
    // a draft written for different questions (the set was edited since) is useless
    return JSON.stringify(d.qids) === JSON.stringify(exam.questions.map(q => q.id)) ? d : null;
  } catch { return null; }
}
function cleanDraft(exam, b) {
  const n = exam.questions.length;
  if (!b || typeof b !== 'object') return null;
  const per = (a, ok) => Array.isArray(a) && a.length === n && a.every(ok);
  const perm = (a, len) => Array.isArray(a) && a.length === len && [...a].sort((x, y) => x - y).every((v, i) => v === i);
  const st = b.settings && typeof b.settings === 'object' ? b.settings : {};
  const feedback = st.feedback === 'each' ? 'each' : 'end';
  const when = Date.parse(b.startedAt);
  if (!per(b.order, (o, i) => perm(o, exam.questions[i].options.length))) return null;
  if (!per(b.answers, (a, i) => a === null || (Number.isInteger(a) && a >= 0 && a < exam.questions[i].options.length))) return null;
  if (!per(b.revealed, v => typeof v === 'boolean') || !per(b.locked, v => typeof v === 'boolean')) return null;
  if (!Number.isInteger(b.pos) || b.pos < 0 || b.pos >= n) return null;
  return { qids: exam.questions.map(q => q.id), startedAt: new Date(Number.isNaN(when) ? Date.now() : when).toISOString(),
    savedAt: new Date().toISOString(), settings: { feedback, back: st.back === true },
    pos: b.pos, order: b.order, answers: b.answers, revealed: b.revealed, locked: b.locked };
}
function deleteDraft(id) { try { fs.unlinkSync(draftFile(id)); } catch { /* none */ } }
function examIndex(lang) {
  let files = [];
  try { files = fs.readdirSync(EXAMS).filter(f => f.endsWith('.json')).map(f => f.slice(0, -5)); } catch { /* no exams yet */ }
  const rank = e => EXAM_TIER_ORDER.indexOf(e.tier) * 1000 + (parseInt(e.id.split('-')[1], 10) || 0);
  return [...files.map(id => loadExam(id, lang)).filter(Boolean).sort((a, b) => rank(a) - rank(b)), ...impExams()].map(e => {
    const at = examAttempts(e.id), last = at[at.length - 1];
    return { id: e.id, title: e.title, about: e.about, tier: e.tier, count: e.questions.length, imp: e.imp, packTitle: e.packTitle,
      attempts: at.length, best: at.length ? Math.max(...at.map(a => a.score)) : null,
      last: last ? { n: last.n, score: last.score, total: last.total, finishedAt: last.finishedAt } : null,
      pass: EXAM_PASS,
      draft: (d => d ? { pos: d.pos, total: e.questions.length, answered: d.answers.filter(a => a !== null).length, savedAt: d.savedAt } : null)(readDraft(e)) };
  });
}
// builds the stored attempt from what the browser sent; never trusts a score it sends
function gradeAttempt(exam, body, prev) {
  const sent = new Map((Array.isArray(body.answers) ? body.answers : []).map(a => [a && a.q, a && a.pick]));
  const answers = exam.questions.map(q => {
    const pick = sent.get(q.id);
    const key = q.options.findIndex(o => o.ok);
    const valid = Number.isInteger(pick) && pick >= 0 && pick < q.options.length;
    return { q: q.id, pick: valid ? pick : null, ok: valid && pick === key };
  });
  const score = answers.filter(a => a.ok).length;
  const when = v => { const t = Date.parse(v); return Number.isNaN(t) ? Date.now() : t; };
  const started = when(body.startedAt), finished = Math.max(started, when(body.finishedAt));
  const st = body.settings && typeof body.settings === 'object' ? body.settings : {};
  const feedback = st.feedback === 'each' ? 'each' : 'end';
  return {
    n: prev.reduce((m, a) => Math.max(m, a.n || 0), 0) + 1,
    startedAt: new Date(started).toISOString(), finishedAt: new Date(finished).toISOString(),
    seconds: Math.round((finished - started) / 1000),
    score, total: exam.questions.length, pass: score >= EXAM_PASS,
    settings: { feedback, back: st.back === true },
    lang: THEORY_LANGS.includes(body.lang) ? body.lang : 'en',
    answers,
  };
}

// ------------------------------------------------------------------ script practice exams
// One bash script per exam, graded out of 10 by objectives (bin/sgrade, lib/engine.sh: grade_exam). Sources:
// tools/src/script-exams/*.txt -> script-exams/<id>_<slug>/{README.md,README.es.md,check.sh,meta.json} (tools/build_script_exams.js).
// Everything the user does lives under .progress/script-exams/: <id>.json (finished attempts, oldest first),
// <id>.attempt.json (the attempt in progress: kept until it is submitted or discarded), <id>/work/<script>
// (the script being written; the terminal and VS Code open there) and <id>/archive/ (earlier scripts).
const SX = path.join(LAB, 'script-exams');
const SX_PROGRESS = path.join(PROGRESS, 'script-exams');
const SX_ID = /^(easy|medium|hard)-\d\d$/;
const SX_PASS = 5;
const SX_MAX_ATTEMPTS = 200;
function sxDir(id) {
  if (!SX_ID.test(id)) return null;
  try { const d = fs.readdirSync(SX).find(n => n.startsWith(id + '_')); return d ? path.join(SX, d) : null; } catch { return null; }
}
function sxMeta(id) {
  const d = sxDir(id);
  if (!d) return null;
  try { return { ...JSON.parse(fs.readFileSync(path.join(d, 'meta.json'), 'utf8')), dir: d }; } catch { return null; }
}
const sxAttemptsFile = id => path.join(SX_PROGRESS, id + '.json');
const sxCurrentFile = id => path.join(SX_PROGRESS, id + '.attempt.json');
const sxWorkDir = id => path.join(SX_PROGRESS, id, 'work');
function sxAttempts(id) {
  try { const a = JSON.parse(fs.readFileSync(sxAttemptsFile(id), 'utf8')); return Array.isArray(a) ? a : []; } catch { return []; }
}
function sxCurrent(id) {
  try { return JSON.parse(fs.readFileSync(sxCurrentFile(id), 'utf8')); } catch { return null; }
}
function sxWrite(file, value) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file + '.tmp', JSON.stringify(value));
  fs.renameSync(file + '.tmp', file);
}
const sxLang = lang => THEORY_LANGS.includes(lang) ? lang : 'en';
const sxText = (o, lang) => (o && (o[lang] || o.en)) || '';
function sxIndex(lang) {
  let dirs = [];
  try { dirs = fs.readdirSync(SX).filter(n => SX_ID.test(n.split('_')[0])); } catch { /* none yet */ }
  const rank = m => EXAM_TIER_ORDER.indexOf(m.tier) * 1000 + (parseInt(m.id.split('-')[1], 10) || 0);
  return dirs.map(n => sxMeta(n.split('_')[0])).filter(Boolean).sort((a, b) => rank(a) - rank(b)).map(m => {
    const at = sxAttempts(m.id), last = at[at.length - 1], cur = sxCurrent(m.id);
    return { id: m.id, tier: m.tier, title: sxText(m.title, lang), script: m.script, cmds: m.cmds, total: m.total, pass: SX_PASS,
      attempts: at.length, best: at.length ? Math.max(...at.map(a => a.score)) : null,
      last: last ? { n: last.n, score: last.score, finishedAt: last.finishedAt } : null,
      inProgress: cur ? { startedAt: cur.startedAt } : null };
  });
}
function sxDetail(m, lang) {
  const readme = fs.readFileSync(path.join(m.dir, lang === 'es' ? 'README.es.md' : 'README.md'), 'utf8');
  const cur = sxCurrent(m.id);
  return { id: m.id, tier: m.tier, title: sxText(m.title, lang), script: m.script, cmds: m.cmds, total: m.total, pass: SX_PASS,
    objectives: m.objectives.map(o => ({ id: o.id, label: sxText(o.label, lang), points: o.points })),
    readme, attempt: cur, workDir: sxWorkDir(m.id), scriptPath: path.join(sxWorkDir(m.id), m.script) };
}
function sxArchive(m, why) {      // keep whatever script is in the work dir before it is replaced
  const file = path.join(sxWorkDir(m.id), m.script);
  if (!isAttempted(file)) return;
  const dest = path.join(SX_PROGRESS, m.id, 'archive');
  fs.mkdirSync(dest, { recursive: true });
  fs.copyFileSync(file, path.join(dest, new Date().toISOString().replace(/[:.]/g, '-') + (why ? '-' + why : '') + '.sh'));
}
function sxStart(m, body) {
  const cur = sxCurrent(m.id);
  if (cur) return cur;                                   // an attempt in progress is resumed, never replaced
  sxArchive(m, 'previous');
  const work = sxWorkDir(m.id), file = path.join(work, m.script);
  fs.mkdirSync(work, { recursive: true });
  fs.writeFileSync(file, `#!/bin/bash\n# ${m.script} — write your solution here\n\n`);
  fs.chmodSync(file, 0o755);
  const st = body.settings && typeof body.settings === 'object' ? body.settings : {};
  const attempt = { startedAt: new Date().toISOString(), settings: { checkAnytime: st.checkAnytime === true }, lang: sxLang(body.lang) };
  sxWrite(sxCurrentFile(m.id), attempt);
  return attempt;
}
function sxGrade(m, file) {       // -> Promise of the parsed bin/sgrade report
  return new Promise((resolve, reject) => {
    const p = spawn(path.join(LAB, 'bin/sgrade'), [m.id, file], { cwd: LAB, env: process.env });
    let out = '', err = '';
    p.stdout.on('data', d => { out += d; });
    p.stderr.on('data', d => { err += d; });
    const timer = setTimeout(() => p.kill(), 300000);
    p.on('error', reject);
    p.on('close', () => {
      clearTimeout(timer);
      const cut = out.indexOf('\n---\n');
      const head = (cut < 0 ? out : out.slice(0, cut)).split('\n');
      const details = (cut < 0 ? err : out.slice(cut + 5)).slice(0, 12000);
      const objectives = head.filter(l => l.startsWith('OBJ|')).map(l => {
        const [, id, , points, passed, cases, earned] = l.split('|');
        return { id, points: +points, passed: +passed, cases: +cases, earned: +earned };
      });
      const sc = head.find(l => l.startsWith('SCORE|'));
      if (!sc || !objectives.length) return reject(new Error('the grader failed: ' + (err || out).slice(0, 400)));
      resolve({ score: +sc.split('|')[1], objectives, details });
    });
  });
}

// ------------------------------------------------------------------ scripts (one script built up in steps)
// scripts/<id>_<slug>/{meta.json, README.<n>.md, check.<n>.sh} are built from tools/src/scripts/*.txt (tools/build_scripts.js). The
// learner's file lives in .progress/scripts/<id>/<name>.sh and keeps growing from step to step; a step passes when bin/check
// <id>.<n> succeeds, which the engine records in .progress/scripts/<id>.steps (a passed step stays passed). A script counts as
// done when every step has passed. These are not tracks exercises: they have their own section and counter.
const SC = path.join(LAB, 'scripts');
const SC_PROGRESS = path.join(PROGRESS, 'scripts');
const SC_ID = /^(s\d\d|imp-[a-z0-9]+(-[a-z0-9]+)*)$/;      // the course scripts, and the scripts of imported packs (imp-<pack>-<item>)
function scDir(id) {
  if (!SC_ID.test(id)) return null;
  try { const d = fs.readdirSync(SC).find(n => n.startsWith(id + '_')); return d ? path.join(SC, d) : null; } catch { return null; }
}
function scMeta(id) {
  const d = scDir(id);
  if (!d) return null;
  try { return { ...JSON.parse(fs.readFileSync(path.join(d, 'meta.json'), 'utf8')), dir: d }; } catch { return null; }
}
function scPassed(id) {
  try { return [...new Set(fs.readFileSync(path.join(SC_PROGRESS, id + '.steps'), 'utf8').split('\n').map(Number).filter(n => n > 0))].sort((a, b) => a - b); }
  catch { return []; }
}
const scAnswer = m => path.join(SC_PROGRESS, m.id, m.script);
const scTemplate = m => `#!/bin/bash\n# ${m.script} — write your script here, then run the step's Check\n\n`;
function scEnsure(m) {          // the learner's file exists from the first visit on (never overwritten here)
  const f = scAnswer(m);
  if (!fs.existsSync(f)) { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, scTemplate(m)); fs.chmodSync(f, 0o755); }
  return f;
}
function scPlay(m) {            // ~/play/<id>/work: the checker's fixture files plus the script, for the terminal and VS Code
  scEnsure(m);
  if (m.imp && !packConsented(m.imp)) return null;      // an imported fixture is code: not before the user has allowed the pack
  const dir = playDirFor(m.id);
  if (!fs.existsSync(dir)) { try { buildPlay(m.id); } catch { /* the terminal falls back to LAB */ } }
  return fs.existsSync(dir) ? dir : null;
}
function scStatus(m, passed) { return passed.length >= m.steps.length ? 'pass' : (passed.length || isAttempted(scAnswer(m))) ? 'attempted' : 'new'; }
function scIndex() {
  let dirs = [];
  try { dirs = fs.readdirSync(SC).filter(n => /^(s\d\d|imp-[a-z0-9-]+)_/.test(n)).sort(); } catch { /* none yet */ }
  return dirs.map(n => scMeta(n.split('_')[0])).filter(Boolean).map(m => {
    const passed = scPassed(m.id);
    return { id: m.id, slug: m.slug, title: m.title, script: m.script, cmds: m.cmds, level: m.level, tags: m.tags, steps: m.steps, passed, status: scStatus(m, passed),
      ...(m.imp ? { imp: m.imp, packTitle: m.packTitle, consent: packConsented(m.imp) } : {}) };
  });
}
function scDetail(m) {
  const passed = scPassed(m.id);
  const steps = m.steps.map(st => ({ ...st, readme: fs.readFileSync(path.join(m.dir, `README.${st.n}.md`), 'utf8') }));
  const current = (steps.find(st => !passed.includes(st.n)) || steps[steps.length - 1]).n;
  const need = m.imp && !packConsented(m.imp);
  return { id: m.id, title: m.title, script: m.script, cmds: m.cmds, level: m.level, tags: m.tags, steps, passed, current, status: scStatus(m, passed),
    answer: scEnsure(m), playDir: scPlay(m), ...(m.imp ? { imp: m.imp, packTitle: m.packTitle, needsConsent: !!need } : {}) };
}
function scSolution(m, n) {
  const f = path.join(LAB, 'solutions/scripts', path.basename(m.dir), `${n}.sh`);
  try { return fs.readFileSync(f, 'utf8'); } catch { return null; }
}

// ------------------------------------------------------------------ practice fixture ("play")
// exercises/<id>/ only holds README.md, check.sh and answer.sh — the actual files a script
// needs to read (created by the checker's setup()) live nowhere on disk until built. So that a
// terminal or VS Code opened on an exercise has something real to test against, we build that
// fixture once per exercise (via `bin/play`, which also symlinks answer.sh — and, when the
// checker installs it under another name, that name too — plus README.md into it) and route the
// terminal/editor there instead of the bare exercise folder. Never rebuilt on a plain open, only
// on an explicit reset, so it doesn't clobber files the learner is experimenting with.
function playDirFor(id) { return path.join(process.env.HOME || '/home/alumno', 'play', id, 'work'); }
// Code of an imported pack runs only through here: with a time limit and, when the system allows it, without a network (a new network
// namespace; the user and group ids stay the same, so permissions behave as usual). Course code is run as before.
let NET_ISOLATION = null;
function sandboxArgs(id, cmd, args) {
  if (!String(id).startsWith('imp-')) return [cmd, args];
  if (NET_ISOLATION === null) {
    try { NET_ISOLATION = require('child_process').spawnSync('unshare', ['-Un', `--map-user=${process.getuid()}`, `--map-group=${process.getgid()}`, 'true']).status === 0; } catch { NET_ISOLATION = false; }
  }
  const iso = NET_ISOLATION ? ['unshare', '-Un', `--map-user=${process.getuid()}`, `--map-group=${process.getgid()}`, '--'] : [];
  return ['timeout', ['-k', '5', '240', ...iso, cmd, ...args]];
}
function buildPlay(id) {
  const [c, a] = sandboxArgs(id, path.join(LAB, 'bin/play'), [id]);
  execFileSync(c, a, { cwd: LAB, stdio: 'ignore' });
}
function ensurePlay(ex) {
  if (ex.quiz) return null; // nothing to run for a quiz
  const dir = playDirFor(ex.id);
  if (!fs.existsSync(dir)) { try { buildPlay(ex.id); } catch { /* leave dir missing, caller cds to LAB */ } }
  return fs.existsSync(dir) ? dir : null;
}

// ------------------------------------------------------------------ checker runs
// The checker's text is streamed as it runs. LAB_REPORT also makes the engine dump the raw data of the first
// failing cases (lib/engine.sh: report_case); once it exits that is parsed and appended as one "\x1e<json>"
// line before the "[exit N]" trailer, which the page turns into its side-by-side diff and hints.
function parseReport(file) {
  const rows = fs.readFileSync(file, 'utf8').split('\n');
  const txt = b => Buffer.from(b || '', 'base64').toString('utf8');
  const list = b => { const a = txt(b).split('\0'); a.pop(); return a; };
  const cases = [], sum = {};
  let cur = {};
  for (const row of rows) {
    if (row === '--') { cases.push(cur); cur = {}; continue; }
    const t = row.indexOf('\t');
    if (t < 0) continue;
    const k = row.slice(0, t), v = row.slice(t + 1);
    if (k === 'summary') sum.line = txt(v);
    else if (k === 'sb') sum.sb = txt(v);
    else if (k === 'env') sum.env = list(v).filter(Boolean);
    else if (k === 'root') sum.root = txt(v) === 'root';
    else if (k === 'args' || k === 'fails') cur[k] = list(v);
    else if (k === 'detail') cur.detail = txt(v).split(' ').filter(Boolean);
    else if (k === 'seed' || k === 'index') cur[k] = Number(txt(v));
    else if (k === 'ref_code' || k === 'usr_code') cur[k] = Number(txt(v));
    else cur[k] = txt(v);
  }
  if (!sum.line) return null;      // the checker stopped early (setup error, quiz, ...): the text says why
  const [ncase, bad, nargs, seeds, script, ...rest] = sum.line.split(' ');
  return { cases, sb: sum.sb, env: sum.env || [], root: !!sum.root, ncase: Number(ncase), bad: Number(bad), nargs: Number(nargs), seeds: Number(seeds), script,
           sorted: rest.includes('sorted'), compare: (rest.filter(x => x && x !== 'sorted').pop() || '').split(',') };
}
function streamCheck(res, args) {
  res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8', 'Cache-Control': 'no-store', 'X-Content-Type-Options': 'nosniff' });
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'lab-report-')), file = path.join(tmp, 'r');
  const [sc, sa] = sandboxArgs(String(args[0]), path.join(LAB, 'bin/check'), args);
  const p = spawn(sc, sa, { cwd: LAB, env: { ...process.env, LAB_COLOR: '1', LAB_REPORT: file } });
  p.stdout.on('data', d => res.write(d));
  p.stderr.on('data', d => res.write(d));
  p.on('close', code => {
    let rep = null;
    try { rep = parseReport(file); } catch { /* no report: the text alone is shown */ }
    fs.rmSync(tmp, { recursive: true, force: true });
    if (rep) res.write('\n\x1e' + JSON.stringify(rep) + '\n');
    res.end(`\n\x1b[2m[exit ${code}]\x1b[0m\n`);
  });
  res.on('close', () => { if (p.exitCode === null) p.kill(); }); // browser went away
}
// "Try with the test files": the fixture of one failing case (its seed), built apart from the practice
// folder so nothing the learner has there is touched. Optional STEP for a script's step.
function buildFailing(id, seed, step) {
  const base = path.join(process.env.HOME || '/home/alumno', 'play', id + '-failing');
  const env = { ...process.env, LAB_PLAY_DIR: base };
  if (step) env.STEP = String(step);
  const [c, a] = sandboxArgs(id, path.join(LAB, 'bin/play'), [id, String(seed)]);
  execFileSync(c, a, { cwd: LAB, stdio: 'ignore', env });
  return { work: path.join(base, 'work'), home: path.join(base, 'home'), stdin: fs.existsSync(path.join(base, 'stdin.txt')) ? path.join(base, 'stdin.txt') : null };
}
const validSeed = v => /^\d{1,10}$/.test(v || '') ? Number(v) : null;

// ------------------------------------------------------------------ multiple answer attempts
// Alongside the canonical answer.sh/.txt (attempt "1", implicitly), an exercise directory may hold
// extra attempts named answer2.sh, answer3.sh, ... — for keeping a previous solve around, or trying
// a different approach, without losing the one that's already passing. They're plain files living
// next to answer.sh; the checker (lib/engine.sh: check_one) already accepts a custom answer-file
// path and, when given one, deliberately skips updating the exercise's pass/fail progress — so
// checking an attempt never disturbs the exercise's official status.
function attemptExt(ex) { return ex.quiz ? '.txt' : '.sh'; }
function attemptRegex(ex) { return new RegExp(`^answer(\\d+)${attemptExt(ex) === '.sh' ? '\\.sh' : '\\.txt'}$`); }
function isValidAttemptFile(ex, name) {
  if (!name || name === path.basename(ex.answer)) return false; // that's the canonical file, no override needed
  return attemptRegex(ex).test(name) && fs.existsSync(path.join(ex.dir, name));
}
function createAttempt(ex, fromName) {
  const ext = attemptExt(ex), re = attemptRegex(ex);
  let maxN = 1; // answer.sh/.txt is implicitly attempt 1
  for (const f of fs.readdirSync(ex.dir)) {
    const m = f.match(re);
    if (m) maxN = Math.max(maxN, parseInt(m[1], 10));
  }
  const name = `answer${maxN + 1}${ext}`;
  const dest = path.join(ex.dir, name);
  const src = isValidAttemptFile(ex, fromName) ? path.join(ex.dir, fromName) : ex.answer;
  fs.copyFileSync(src, dest);
  fs.chmodSync(dest, 0o755);
  let openPath = dest;
  const playDir = ensurePlay(ex);
  if (playDir) {
    const link = path.join(playDir, name);
    try { fs.unlinkSync(link); } catch { /* didn't exist yet */ }
    fs.symlinkSync(dest, link);
    openPath = link;
  }
  return { name, path: dest, openPath };
}

// ------------------------------------------------------------------ http helpers
function send(res, code, body, type = 'application/json') {
  res.writeHead(code, { 'Content-Type': type, 'Cache-Control': 'no-store' });
  res.end(type === 'application/json' ? JSON.stringify(body) : body);
}

const MIME = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.svg': 'image/svg+xml',
               '.map': 'application/json', '.json': 'application/json', '.woff2': 'font/woff2' };
function serveFile(res, file) {
  fs.readFile(file, (err, data) => {
    if (err) return send(res, 404, 'not found', 'text/plain');
    res.writeHead(200, { 'Content-Type': MIME[path.extname(file)] || 'application/octet-stream' });
    res.end(data);
  });
}

// the only third-party files the page loads (served locally: works offline)
const VENDOR_FILES = {
  'xterm.js': '@xterm/xterm/lib/xterm.js',
  'xterm.css': '@xterm/xterm/css/xterm.css',
  'addon-fit.js': '@xterm/addon-fit/lib/addon-fit.js',
  'marked.js': 'marked/marked.min.js',
};

function readBody(req) {
  return new Promise(resolve => {
    let b = '';
    req.on('data', c => { b += c; if (b.length > 1e5) req.destroy(); });
    req.on('end', () => { try { resolve(JSON.parse(b || '{}')); } catch { resolve({}); } });
  });
}

function setVSCodeTheme(theme) {
  let s = {};
  try { s = JSON.parse(fs.readFileSync(CS_SETTINGS, 'utf8')); } catch { /* fresh file */ }
  s['workbench.colorTheme'] = theme === 'light' ? 'Default Light Modern' : 'Default Dark Modern';
  fs.mkdirSync(path.dirname(CS_SETTINGS), { recursive: true });
  fs.writeFileSync(CS_SETTINGS, JSON.stringify(s, null, 2));
}

// ------------------------------------------------------------------ security
// The terminal is a real shell, so only pages served from this very server may use it:
// - Host must be localhost/127.0.0.1 (defeats DNS rebinding)
// - Origin, when present (browsers always send it for websockets and cross-site POSTs),
//   must be the same host (defeats other websites talking to localhost)
const LOCAL_HOST = /^(localhost|127\.0\.0\.1|\[::1\])(:\d+)?$/;
function trusted(req) {
  const host = req.headers.host || '';
  if (!LOCAL_HOST.test(host)) return false;
  const origin = req.headers.origin;
  if (!origin) return true;
  try { return new URL(origin).host === host; } catch { return false; }
}

// ------------------------------------------------------------------ routes
async function api(req, res, url) {
  const parts = url.pathname.split('/').filter(Boolean); // ['api', ...]
  if (parts[1] === 'ping') return send(res, 200, { ok: true });

  if (parts[1] === 'index' && req.method === 'GET') {
    return send(res, 200, index().map(t => ({
      ...t, exercises: t.exercises.map(({ dir, answer, ...e }) => e),
    })));
  }

  if (parts[1] === 'import') {
    if (req.method === 'GET' && !parts[2]) return send(res, 200, readPacks().map(p => ({ ...importer.summarize(p), ...packStatus(p) })));
    if (req.method === 'GET' && parts[2] === 'history') return send(res, 200, readHistory().slice(-200).reverse());
    if (req.method === 'POST' && parts[2] === 'history' && parts[3] === 'clear') { try { fs.unlinkSync(HISTORY_FILE); } catch { /* none */ } return send(res, 200, { ok: true }); }
    if (req.method === 'GET' && (parts[2] === 'prompt.md' || parts[2] === 'example.json')) {
      const file = path.join(__dirname, parts[2] === 'prompt.md' ? 'import-prompt.md' : 'import-example.json');
      let text; try { text = fs.readFileSync(file, 'utf8'); } catch { return send(res, 404, { error: 'file missing' }); }
      res.writeHead(200, { 'Content-Type': parts[2] === 'prompt.md' ? 'text/markdown; charset=utf-8' : 'application/json; charset=utf-8',
        'Content-Disposition': `attachment; filename="${parts[2] === 'prompt.md' ? 'bash-stash-import-prompt.md' : 'bash-stash-example-pack.json'}"`, 'Cache-Control': 'no-store' });
      return res.end(text);
    }
    if (req.method === 'POST' && (parts[2] === 'validate' || !parts[2])) {
      const body = await readRaw(req);
      if (body.error) return send(res, 413, { ok: false, errors: [{ at: 'file', msg: body.error }], warnings: [] });
      let raw;
      try { raw = JSON.parse(body.text); } catch (e) { return send(res, 422, { ok: false, errors: [{ at: 'file', msg: 'This is not valid JSON: ' + e.message }], warnings: [] }); }
      const v = importer.validatePack(raw);
      if (!v.ok) return send(res, 422, { ok: false, errors: v.errors.slice(0, 60), warnings: v.warnings.slice(0, 30), moreErrors: Math.max(0, v.errors.length - 60) });
      const exists = readPacks().some(p => p.id === v.pack.id);
      if (parts[2] === 'validate') return send(res, 200, { ok: true, warnings: v.warnings.slice(0, 30), summary: importer.summarize(v.pack), exists });
      if (exists && url.searchParams.get('replace') !== '1') return send(res, 409, { ok: false, exists: true, errors: [{ at: 'file', msg: `A pack called "${v.pack.id}" is already imported.` }], warnings: [] });
      const old = readPacks().find(p => p.id === v.pack.id);
      v.pack.addedAt = old ? old.addedAt : new Date().toISOString();
      writePack(v.pack);
      syncMaterialized();
      const from = (url.searchParams.get('file') || '').slice(0, 120);
      logHistory(old ? 'replaced' : 'added', v.pack, `${itemsLine(v.pack)}${old ? ` (before: ${itemsLine(old)})` : ''}${from ? ` · file ${from}` : ''}`);
      return send(res, 200, { ok: true, warnings: v.warnings.slice(0, 30), summary: importer.summarize(v.pack) });
    }
    if (importer.SLUG.test(parts[2] || '') && ['code', 'consent', 'rollback', 'selftest'].includes(parts[3])) {
      const pack = readPacks().find(p => p.id === parts[2]);
      if (!pack) return send(res, 404, { error: 'no such pack' });
      if (req.method === 'GET' && parts[3] === 'code') {
        const scan = require('./scanner').scan;
        return send(res, 200, { id: pack.id, title: pack.title, ...packStatus(pack), items: scriptItems(pack).map(i => ({ id: i.id, title: i.title, script: i.script,
          fixture: { code: i.fixture, findings: i.fixture ? scan(i.fixture) : [] },
          steps: i.steps.map(st => ({ n: st.n, title: st.title, check: { code: st.check, findings: scan(st.check) }, solution: { code: st.solution, findings: scan(st.solution) } })) })) });
      }
      if (req.method === 'POST' && parts[3] === 'consent') {          // "I have read the code": a snapshot of the progress first, then the pack may run
        if (!scriptItems(pack).length) return send(res, 200, { ok: true });
        try { takeSnapshot(pack.id); } catch (e) { return send(res, 500, { error: 'The snapshot of your progress could not be made, so the pack was not allowed: ' + e.message }); }
        fs.writeFileSync(consentFile(pack.id), JSON.stringify({ hash: packCodeHash(pack), at: new Date().toISOString() }));
        logHistory('allowed', pack, 'its code may run in the sandbox; a snapshot of your progress and answers was saved first');
        return send(res, 200, { ok: true });
      }
      if (req.method === 'POST' && parts[3] === 'rollback') {
        let ok = false;
        try { ok = restoreSnapshot(pack.id); } catch (e) { return send(res, 500, { error: e.message }); }
        if (!ok) return send(res, 404, { error: 'There is no snapshot of this pack.' });
        logHistory('rolled back', pack, 'progress and answers restored to what they were before the pack first ran');
        return send(res, 200, { ok: true });
      }
      if (req.method === 'POST' && parts[3] === 'selftest') {         // every step: its own solution passes the checker, an empty script does not
        if (!packConsented(pack.id)) return send(res, 403, { error: 'consent', imp: pack.id });
        const noop = path.join(os.tmpdir(), `bs-noop-${process.pid}.sh`);
        fs.writeFileSync(noop, '#!/bin/bash\ntrue\n');
        const results = [];
        const run = (idstep, file) => new Promise(resolve => {
          const [c, a] = sandboxArgs(idstep, path.join(LAB, 'bin/check'), [idstep, file]);
          let out = '';
          const ch = spawn(c, a, { cwd: LAB, env: { ...process.env, LAB_COLOR: '' } });
          ch.stdout.on('data', d => { out += d; }); ch.stderr.on('data', d => { out += d; });
          ch.on('close', code => resolve({ code, out: out.split('\n').slice(-14).join('\n') }));
        });
        for (const it of scriptItems(pack)) {
          const id = `imp-${pack.id}-${it.id}`, sol = n => path.join(LAB, 'solutions/scripts', `${id}_script`, `${n}.sh`);
          for (const st of it.steps) {
            const a = await run(`${id}.${st.n}`, sol(st.n));
            const b = await run(`${id}.${st.n}`, noop);
            const c = st.n > 1 ? await run(`${id}.${st.n}`, sol(st.n - 1)) : null;
            results.push({ item: it.id, title: it.title, n: st.n, stepTitle: st.title, refPasses: a.code === 0, emptyFails: b.code !== 0, previousFails: c ? c.code !== 0 : null, detail: a.code === 0 ? '' : a.out });
          }
        }
        try { fs.unlinkSync(noop); } catch { /* gone */ }
        logHistory('self-test', pack, `${results.filter(r => r.refPasses && r.emptyFails && r.previousFails !== false).length}/${results.length} steps fine`);
        return send(res, 200, { results });
      }
    }
    if (req.method === 'POST' && parts[3] === 'delete' && importer.SLUG.test(parts[2] || '')) {
      const pack = readPacks().find(p => p.id === parts[2]);
      const withProgress = (await readBody(req)).progress !== false;
      deletePack(parts[2], withProgress);
      syncMaterialized();
      if (pack) logHistory('removed', pack, `${itemsLine(pack)}${withProgress ? ' · its progress was deleted too' : ' · its progress was kept'}`);
      return send(res, 200, { ok: true });
    }
    if (req.method === 'POST' && parts[3] === 'rename' && importer.SLUG.test(parts[2] || '')) {
      const pack = readPacks().find(p => p.id === parts[2]);
      if (!pack) return send(res, 404, { error: 'no such pack' });
      const title = String((await readBody(req)).title || '').trim();
      if (!title || title.length > 200) return send(res, 422, { error: 'The name must have between 1 and 200 characters.' });
      if (title === pack.title) return send(res, 200, { ok: true });
      const was = pack.title;
      pack.title = title;
      writePack(pack);
      logHistory('renamed', pack, `“${was}” → “${title}”`);
      return send(res, 200, { ok: true });
    }
    return send(res, 404, { error: 'unknown endpoint' });
  }

  if (parts[1] === 'theory') {
    const lang = url.searchParams.get('lang');
    if (req.method === 'GET' && !parts[2]) return send(res, 200, theoryIndex(lang));
    const col = parts[2] ? loadCollection(parts[2], lang) : null;
    if (!col) return send(res, 404, { error: 'no such collection' });
    if (req.method === 'GET' && !parts[3]) return send(res, 200, col);
    if (req.method === 'POST' && parts[3] === 'reset') {
      try { fs.unlinkSync(path.join(THEORY_PROGRESS, col.id + '.json')); } catch { /* nothing stored */ }
      return send(res, 200, { ok: true });
    }
    if (req.method === 'POST' && parts[3] && SAFE_ID.test(parts[3])) {
      const known = col.groups.some(g => g.questions.some(q => q.id === parts[3]));
      if (!known) return send(res, 404, { error: 'no such question' });
      const body = await readBody(req);
      const prog = theoryProgress(col.id);
      const cur = prog[parts[3]] || { pass: false, tries: 0 };
      cur.tries += 1;
      if (body.ok === true) cur.pass = true; // once passed, it stays passed
      prog[parts[3]] = cur;
      writeTheoryProgress(col.id, prog);
      return send(res, 200, { status: questionStatus(cur) });
    }
    return send(res, 404, { error: 'unknown endpoint' });
  }

  if (parts[1] === 'exams') {
    const lang = url.searchParams.get('lang');
    if (req.method === 'GET' && !parts[2]) return send(res, 200, examIndex(lang));
    if (req.method === 'GET' && parts[2] === 'stats' && !parts[3]) return send(res, 200, examStats());
    const exam = parts[2] ? loadExam(parts[2], lang) : null;
    if (!exam) return send(res, 404, { error: 'no such exam' });
    if (req.method === 'GET' && !parts[3]) return send(res, 200, exam);
    if (parts[3] === 'attempts' && req.method === 'GET') return send(res, 200, examAttempts(exam.id));
    if (parts[3] === 'attempts' && req.method === 'POST') {
      const body = await readBody(req);
      const key = loadExam(exam.id) || exam;   // the answer key never depends on the language
      const prev = examAttempts(exam.id);
      const attempt = gradeAttempt(key, body || {}, prev);
      writeExamAttempts(exam.id, [...prev, attempt].slice(-EXAM_MAX_ATTEMPTS));
      deleteDraft(exam.id);                      // a finished attempt is no longer "in progress"
      return send(res, 200, attempt);
    }
    if (parts[3] === 'draft' && req.method === 'GET') return send(res, 200, readDraft(loadExam(exam.id) || exam));
    if (parts[3] === 'draft' && req.method === 'POST') {
      const key = loadExam(exam.id) || exam;
      if (parts[4] === 'delete') { deleteDraft(exam.id); return send(res, 200, { ok: true }); }
      const d = cleanDraft(key, await readBody(req));
      if (!d) return send(res, 400, { error: 'invalid draft' });
      fs.mkdirSync(EXAM_PROGRESS, { recursive: true });
      fs.writeFileSync(draftFile(exam.id) + '.tmp', JSON.stringify(d));
      fs.renameSync(draftFile(exam.id) + '.tmp', draftFile(exam.id));
      return send(res, 200, { ok: true });
    }
    if (parts[3] === 'reset' && req.method === 'POST') {
      try { fs.unlinkSync(path.join(EXAM_PROGRESS, exam.id + '.json')); } catch { /* nothing stored */ }
      return send(res, 200, { ok: true });
    }
    return send(res, 404, { error: 'unknown endpoint' });
  }

  if (parts[1] === 'scripts') {
    if (req.method === 'GET' && !parts[2]) return send(res, 200, scIndex());
    const m = parts[2] ? scMeta(parts[2]) : null;
    if (!m) return send(res, 404, { error: 'no such script' });
    const step = Number(url.searchParams.get('step'));
    if (req.method === 'GET' && !parts[3]) return send(res, 200, scDetail(m));
    if (m.imp && ['check', 'play', 'reset'].includes(parts[3]) && !packConsented(m.imp)) return send(res, 403, { error: 'consent', imp: m.imp });
    if (parts[3] === 'check' && req.method === 'POST') {
      if (!m.steps.some(st => st.n === step)) return send(res, 400, { error: 'no such step' });
      scEnsure(m);
      return streamCheck(res, [`${m.id}.${step}`]);
    }
    if (parts[3] === 'markall' && req.method === 'POST') {    // full-instructions mode: the whole script passed (its last step did), so every step counts
      const have = scPassed(m.id), last = m.steps[m.steps.length - 1].n;
      if (!have.includes(last)) return send(res, 409, { error: 'the last step has not passed' });
      fs.mkdirSync(SC_PROGRESS, { recursive: true });
      fs.appendFileSync(path.join(SC_PROGRESS, m.id + '.steps'), m.steps.map(st => st.n).filter(n => !have.includes(n)).map(n => n + '\n').join(''));
      return send(res, 200, { ok: true });
    }
    if (parts[3] === 'solution' && req.method === 'POST') {
      const content = m.steps.some(st => st.n === step) ? scSolution(m, step) : null;
      return content == null ? send(res, 404, { error: 'no solution' }) : send(res, 200, { file: `solutions/scripts/${path.basename(m.dir)}/${step}.sh`, content });
    }
    if (parts[3] === 'load' && req.method === 'POST') {    // replace the learner's file with the reference code of a step (0 = empty template)
      const body = await readBody(req);
      const n = Number(body.step);
      const text = n === 0 ? scTemplate(m) : m.steps.some(st => st.n === n) ? scSolution(m, n) : null;
      if (text == null) return send(res, 400, { error: 'no such step' });
      const f = scEnsure(m);
      if (isAttempted(f)) {                                  // never lose what is there: it is archived first
        const arch = path.join(SC_PROGRESS, m.id, 'archive');
        fs.mkdirSync(arch, { recursive: true });
        fs.copyFileSync(f, path.join(arch, new Date().toISOString().replace(/[:.]/g, '-') + '.sh'));
      }
      fs.writeFileSync(f, text); fs.chmodSync(f, 0o755);
      return send(res, 200, { ok: true });
    }
    if (parts[3] === 'play' && req.method === 'POST') {
      const seed = validSeed(url.searchParams.get('seed'));
      if (seed == null || !m.steps.some(st => st.n === step)) return send(res, 400, { error: 'bad seed or step' });
      scEnsure(m);
      try { return send(res, 200, { ...buildFailing(m.id, seed, step), script: m.script }); }
      catch (e) { return send(res, 500, { error: String(e) }); }
    }
    if (parts[3] === 'reset' && req.method === 'POST') {
      try { buildPlay(m.id); } catch (e) { return send(res, 500, { error: String(e) }); }
      return send(res, 200, { playDir: playDirFor(m.id) });
    }
    return send(res, 404, { error: 'unknown endpoint' });
  }

  if (parts[1] === 'sexams') {
    const lang = sxLang(url.searchParams.get('lang'));
    if (req.method === 'GET' && !parts[2]) return send(res, 200, sxIndex(lang));
    const m = parts[2] ? sxMeta(parts[2]) : null;
    if (!m) return send(res, 404, { error: 'no such script exam' });
    if (req.method === 'GET' && !parts[3]) return send(res, 200, sxDetail(m, lang));
    if (parts[3] === 'attempts' && req.method === 'GET') return send(res, 200, sxAttempts(m.id));
    if (parts[3] === 'start' && req.method === 'POST') {
      const body = await readBody(req);
      try { sxStart(m, body || {}); } catch (e) { return send(res, 500, { error: String(e) }); }
      return send(res, 200, sxDetail(m, lang));
    }
    if (parts[3] === 'discard' && req.method === 'POST') {
      try { sxArchive(m, 'discarded'); fs.unlinkSync(sxCurrentFile(m.id)); } catch { /* nothing in progress */ }
      return send(res, 200, { ok: true });
    }
    if (parts[3] === 'check' && req.method === 'POST') {
      const cur = sxCurrent(m.id);
      if (!cur) return send(res, 409, { error: 'no attempt in progress' });
      if (!cur.settings.checkAnytime) return send(res, 403, { error: 'this attempt grades only when you submit it' });
      return streamCheck(res, [m.id, path.join(sxWorkDir(m.id), m.script)]);
    }
    if (parts[3] === 'submit' && req.method === 'POST') {
      const cur = sxCurrent(m.id);
      if (!cur) return send(res, 409, { error: 'no attempt in progress' });
      const file = path.join(sxWorkDir(m.id), m.script);
      let graded;
      try { graded = await sxGrade(m, file); } catch (e) { return send(res, 500, { error: String(e.message || e) }); }
      const prev = sxAttempts(m.id), finished = Date.now(), started = Date.parse(cur.startedAt) || finished;
      let script = '';
      try { script = fs.readFileSync(file, 'utf8').slice(0, 30000); } catch { /* missing */ }
      const attempt = {
        n: prev.reduce((mx, a) => Math.max(mx, a.n || 0), 0) + 1,
        startedAt: new Date(started).toISOString(), finishedAt: new Date(finished).toISOString(),
        seconds: Math.round((finished - started) / 1000),
        score: Math.round(graded.score * 10) / 10, total: m.total, pass: graded.score >= SX_PASS,
        settings: cur.settings, lang: cur.lang || 'en', objectives: graded.objectives, details: graded.details, script,
      };
      sxArchive(m, 'submitted');
      sxWrite(sxAttemptsFile(m.id), [...prev, attempt].slice(-SX_MAX_ATTEMPTS));
      try { fs.unlinkSync(sxCurrentFile(m.id)); } catch { /* already gone */ }
      return send(res, 200, attempt);
    }
    if (parts[3] === 'solution' && req.method === 'POST') {
      if (sxCurrent(m.id)) return send(res, 403, { error: 'finish or discard the attempt in progress first' });
      const f = path.join(LAB, 'solutions/script-exams', path.basename(m.dir) + '.sh');
      try { return send(res, 200, { content: fs.readFileSync(f, 'utf8') }); } catch { return send(res, 404, { error: 'no reference solution' }); }
    }
    if (parts[3] === 'reset' && req.method === 'POST') {
      try { fs.unlinkSync(sxAttemptsFile(m.id)); } catch { /* nothing stored */ }
      return send(res, 200, { ok: true });
    }
    return send(res, 404, { error: 'unknown endpoint' });
  }

  const ex = parts[2] ? findExercise(parts[2]) : null;
  if (['exercise', 'check', 'solution', 'reset', 'attempt', 'play'].includes(parts[1]) && !ex) return send(res, 404, { error: 'no such exercise' });

  if (parts[1] === 'exercise' && req.method === 'GET') {
    const readme = stripCliFooter(fs.readFileSync(path.join(ex.dir, 'README.md'), 'utf8'));
    const playDir = ensurePlay(ex);
    return send(res, 200, { id: ex.id, title: ex.title, level: ex.level, cmds: ex.cmds, quiz: ex.quiz,
      status: ex.status, readme, dir: ex.dir, answer: ex.answer, topic: ex.topic.title, playDir });
  }

  if (parts[1] === 'reset' && req.method === 'POST') {
    if (ex.quiz) return send(res, 400, { error: 'nothing to reset for a quiz' });
    try { buildPlay(ex.id); } catch (e) { return send(res, 500, { error: String(e) }); }
    return send(res, 200, { playDir: playDirFor(ex.id) });
  }

  if (parts[1] === 'play' && req.method === 'POST') {
    const seed = validSeed(url.searchParams.get('seed'));
    if (seed == null || ex.quiz) return send(res, 400, { error: 'bad seed' });
    try { return send(res, 200, { ...buildFailing(ex.id, seed), script: 'answer.sh' }); }
    catch (e) { return send(res, 500, { error: String(e) }); }
  }

  if (parts[1] === 'attempt' && req.method === 'POST') {
    const body = await readBody(req);
    try { return send(res, 200, createAttempt(ex, body.from)); }
    catch (e) { return send(res, 500, { error: String(e) }); }
  }

  if (parts[1] === 'check' && req.method === 'POST') {
    // an explicit ?file=answerN.sh checks that attempt instead of the canonical answer.sh/.txt —
    // isValidAttemptFile rejects anything else (wrong exercise, made-up name, canonical file itself)
    const fileArg = url.searchParams.get('file');
    const args = [ex.id];
    if (isValidAttemptFile(ex, fileArg)) args.push(path.join(ex.dir, fileArg));
    return streamCheck(res, args);   // the real checker's output (ANSI colours) as it runs, then its report
  }

  if (parts[1] === 'solution' && req.method === 'POST') {
    const body = await readBody(req);
    if (ex.status !== 'pass') {
      if (!body.confirm) return send(res, 409, { error: 'confirm required' });
      fs.mkdirSync(PROGRESS, { recursive: true });
      fs.writeFileSync(path.join(PROGRESS, ex.id + '.viewed'), 'viewed\n');
    }
    const file = solutionFile(ex);
    return send(res, 200, { file: path.relative(LAB, file), content: fs.readFileSync(file, 'utf8') });
  }

  if (parts[1] === 'theme' && req.method === 'POST') {
    const body = await readBody(req);
    try { setVSCodeTheme(body.theme); } catch (e) { return send(res, 500, { error: String(e) }); }
    return send(res, 200, { ok: true });
  }

  return send(res, 404, { error: 'unknown endpoint' });
}

// code-server has no settings for "start with the file-explorer sidebar closed" or "start with the
// integrated terminal open" (both are UI/session state, not settings), so a tiny script is injected
// into its HTML that does both once, right after the workbench renders:
//  - sidebar: a real click on the already-active explorer icon (what closing it by hand does) —
//    far more reliable than a keybinding for this one, since it's a plain DOM click.
//  - terminal: a synthetic Ctrl+` keydown (VS Code's own default "toggle terminal" shortcut) —
//    unlike the sidebar there is no single icon to click for "open, at whatever the default height
//    is", so the keybinding is dispatched instead; VS Code's keybinding service does not require a
//    trusted event for this one, confirmed empirically.
// It also reports the currently focused editor tab's filename to the parent page (postMessage),
// polled from the tab bar's DOM (`.tab.active[data-resource-name]`) since code-server exposes no
// API for this — the parent uses it to let "Check" run against whichever answer*.sh is focused,
// instead of only the canonical answer.sh.
const WORKBENCH_TWEAKS = nonce => `<script nonce="${nonce}">(function(){
  var tries = 0, closedSidebar = false, openedTerminal = false;
  var t = setInterval(function() {
    if (++tries > 600 || (closedSidebar && openedTerminal)) return clearInterval(t); // ~2 minutes max
    if (!closedSidebar) {
      var sidebar = document.querySelector('.part.sidebar');
      if (sidebar && sidebar.offsetWidth > 0) {
        var icon = document.querySelector('.activitybar .action-item.checked, .activitybar .action-item.active');
        if (icon) { icon.click(); closedSidebar = true; }
      }
    }
    if (!openedTerminal) {
      var panel = document.querySelector('.part.panel');
      if (panel && panel.offsetHeight > 0) { openedTerminal = true; } // confirmed open, stop retrying
      else if (document.querySelector('.monaco-workbench')) {
        var ev = { key: '\`', code: 'Backquote', keyCode: 192, which: 192, ctrlKey: true, bubbles: true, cancelable: true, composed: true };
        var kd = new KeyboardEvent('keydown', ev);
        document.dispatchEvent(kd); window.dispatchEvent(kd);
        if (document.activeElement) document.activeElement.dispatchEvent(kd);
      }
    }
  }, 200);
  var lastActive = null;
  setInterval(function() {
    var tab = document.querySelector('.tabs-container .tab.active');
    var name = tab ? tab.getAttribute('data-resource-name') : null;
    if (name !== lastActive) {
      lastActive = name;
      try { window.parent.postMessage({ source: 'bash-stash-vscode', activeFile: name }, window.location.origin); } catch (e) {}
    }
  }, 500);
})();</script>`;

const proxy = httpProxy.createProxyServer({ target: CODE_SERVER, ws: true, changeOrigin: false, selfHandleResponse: true });
proxy.on('error', (err, req, res) => {
  if (res && res.writeHead && !res.headersSent) {
    send(res, 502, 'VS Code (code-server) is starting or not available. Reload in a few seconds.', 'text/plain');
  } else if (res && res.destroy) res.destroy();
});
proxy.on('proxyRes', (proxyRes, req, res) => {
  const ct = proxyRes.headers['content-type'] || '';
  if (!ct.includes('text/html')) { res.writeHead(proxyRes.statusCode, proxyRes.headers); return proxyRes.pipe(res); }
  const chunks = [];
  proxyRes.on('data', c => chunks.push(c));
  proxyRes.on('end', () => {
    const raw = Buffer.concat(chunks);
    const enc = proxyRes.headers['content-encoding'];
    const decompress = enc === 'gzip' ? zlib.gunzipSync : enc === 'br' ? zlib.brotliDecompressSync
      : enc === 'deflate' ? zlib.inflateSync : null;
    let body;
    try { body = decompress ? decompress(raw) : raw; } catch { body = raw; }
    const htmlStr = body.toString('utf8');
    // code-server's CSP only allows inline scripts carrying its own per-response nonce
    const nonceMatch = htmlStr.match(/<script nonce="([^"]+)"/);
    const html = nonceMatch ? htmlStr.replace('</body>', WORKBENCH_TWEAKS(nonceMatch[1]) + '</body>') : htmlStr;
    const out = Buffer.from(html, 'utf8');
    const headers = { ...proxyRes.headers, 'content-length': out.length };
    delete headers['content-encoding'];
    res.writeHead(proxyRes.statusCode, headers);
    res.end(out);
  });
});

function stripVscodePrefix(req) {
  req.url = req.url.replace(/^\/vscode/, '') || '/';
}

const server = http.createServer((req, res) => {
  if (!trusted(req)) return send(res, 403, 'forbidden: open bash stash at http://localhost:' + PORT, 'text/plain');
  const url = new URL(req.url, 'http://localhost');
  if (url.pathname === '/vscode') { res.writeHead(302, { Location: '/vscode/' }); return res.end(); }
  if (url.pathname.startsWith('/vscode/')) { stripVscodePrefix(req); return proxy.web(req, res); }
  if (url.pathname.startsWith('/api/')) {
    return api(req, res, url).catch(e => send(res, 500, { error: String(e) }));
  }
  if (url.pathname.startsWith('/vendor/')) {
    const f = VENDOR_FILES[url.pathname.slice('/vendor/'.length)];
    return f ? serveFile(res, path.join(VENDOR, f)) : send(res, 404, 'not found', 'text/plain');
  }
  const rel = url.pathname === '/' ? 'index.html' : url.pathname.slice(1);
  const file = path.normalize(path.join(PUBLIC, rel));
  if (!file.startsWith(PUBLIC + path.sep)) return send(res, 403, 'forbidden', 'text/plain');
  return serveFile(res, file);
});

// ------------------------------------------------------------------ terminal (websocket)
const wss = new WebSocketServer({ noServer: true });
wss.on('connection', (ws, req) => {
  const url = new URL(req.url, 'http://localhost');
  const ex = url.searchParams.get('ex') ? findExercise(url.searchParams.get('ex')) : null;
  const sx = SX_ID.test(url.searchParams.get('sx') || '') ? sxWorkDir(url.searchParams.get('sx')) : null;   // a script exam: its work dir
  const sc = SC_ID.test(url.searchParams.get('sc') || '') ? scMeta(url.searchParams.get('sc')) : null;   // a script: its fixture dir
  const term = pty.spawn('bash', ['-l'], {
    name: 'xterm-256color',
    cols: Number(url.searchParams.get('cols')) || 80,
    rows: Number(url.searchParams.get('rows')) || 24,
    cwd: sc && scPlay(sc) ? scPlay(sc) : sx && fs.existsSync(sx) ? sx : ex ? (ensurePlay(ex) || ex.dir) : LAB,
    env: { ...process.env, TERM: 'xterm-256color', LAB_QUIET: '1' },
  });
  term.onData(d => { if (ws.readyState === ws.OPEN) ws.send(d); });
  term.onExit(() => ws.close());
  ws.on('message', raw => {
    let m; try { m = JSON.parse(raw); } catch { return; }
    if (m.t === 'i' && typeof m.d === 'string') term.write(m.d);
    else if (m.t === 'r' && m.c > 0 && m.r > 0) term.resize(Math.min(m.c, 500), Math.min(m.r, 200));
  });
  ws.on('close', () => { try { term.kill(); } catch { /* already gone */ } });
});

server.on('upgrade', (req, socket, head) => {
  if (!trusted(req)) return socket.destroy();
  if (req.url.startsWith('/pty')) {
    wss.handleUpgrade(req, socket, head, ws => wss.emit('connection', ws, req));
  } else if (req.url.startsWith('/vscode/')) {
    stripVscodePrefix(req);
    proxy.ws(req, socket, head);
  } else socket.destroy();
});

try { syncMaterialized(); } catch (e) { console.error('imported scripts:', e.message); }     // the folders of the imported scripts follow the packs
server.listen(PORT, '0.0.0.0', () => console.log(`bash stash web UI on :${PORT}`));
