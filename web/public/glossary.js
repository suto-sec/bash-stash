// Turns the "Commands:" line of an exercise / script into entries of the Reference manual (manual.js + manual-*.js).
// A token that no entry knows is returned as {key, name, desc: null}; the Info panel then leaves it out.
function explainToken(token) {
  const m = MANUAL.lookup(token);
  return m ? { ...m, desc: m.summary } : { key: token.trim().toLowerCase(), name: token.trim(), desc: null };
}

// Splits a "Commands:" string into distinct, explained entries.
function explainCmds(cmdsStr) {
  const seen = new Set();
  const out = [];
  for (const raw of (cmdsStr || '').split(',')) {
    const tok = raw.trim();
    if (!tok) continue;
    const e = explainToken(tok);
    if (seen.has(e.key)) continue;
    seen.add(e.key);
    out.push(e);
  }
  return out;
}
