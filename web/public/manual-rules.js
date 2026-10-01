'use strict';
// Rules for the "Commands:" tokens of the exercises that are syntax, not words (`${v%.*}`, `$(( ))`, `2>&1`, `{1..5}` ...):
// the first rule that matches decides which entry is opened. Words and options (`find -name`) are handled by the entries' `aliases`.
(() => {
  const r = MANUAL.rule;
  r(/^\$\{[^}]*\[[^\]]*\]/, 'arrays');                 // ${arr[@]} ${#arr[@]} ${!arr[@]} ${arr[i]}
  r(/^\$\{/, 'parameter-expansion');                    // ${v:-d} ${v%.*} ${#v} ${v//a/b}
  r(/^\$\(\(|^\(\(|^\$\(\s*\(/, 'arithmetic');          // $(( )) (( ))  ($( $( ) ) is handled below
  r(/^\$\(|^`/, 'command-substitution');                // $(cmd) `cmd`
  r(/^\$[#@*?!$_0-9-]|^"\$[@*#]"/, 'special-parameters'); // $# $@ $? $1 "$@"
  r(/^\$[A-Za-z_]/, 'variables');                       // $HOME $VAR
  r(/^\{[^}]*(\.\.|,)[^}]*\}$/, 'brace-expansion');     // {a..z} {1..N} {a,b}
  r(/^\[\[:|^\[\^|^\\\(|\\\d|^\^|^\[[^\]]*\]$|^\+ \? \{/, 'regex'); // [[:digit:]] [^ ] \( \) \1 ^ [a-z] + ? {n,m}
  r(/^\(\s|^\{\s/, 'subshell-and-group');               // ( ... ) { ...; }
  r(/(^|\s)(\d*>>?|&>>?|\d*<|\d*>&\d|>&\d|\d>&-)/, 'redirection'); // > >> < 2> 2>&1 &> 3>&1
  r(/^<<|^<</, 'heredoc');
  r(/^[0-9]*[#] *\.\.|^\d+#|^\/ % \*\*|^\+\+$|^\+=$|^\$\(\( *[0-9]*#/, 'arithmetic'); // 10#.. / % ** ++ +=
  r(/^-(xtype|samefile|inum|writable|executable|readable|perm|links|newer|empty|mtime|mmin|atime|ctime|size|user|group|nouser|nogroup|depth|mindepth|maxdepth|xdev|prune|path|ipath|regex|iregex|iname|name|type|print0|printf|print|ls|delete|exec|ok|quit|not|a|o)\b/, 'find');
  r(/^(\(\))?arr=\(|^[a-z_]+=\(/, 'arrays');
  r(/^\\\$|^\\n|^'|^"/, 'quoting');
  // fragments left when a token with a comma (`{n,m}`, `{x,y}`) was split
  r(/^\{n|^m\}$|^\{n\}$|^alternatives$|^\\b$|^\$$/, 'regex');
  r(/^\{x$|^y\}$/, 'brace-expansion');
  r(/^\}$/, 'subshell-and-group');
  r(/^-(nt|ot|ef|lt|le|gt|ge|eq|ne)\b/, 'test');
  r(/^-k n|^multiple keys/, 'sort');
  r(/^-[BCw]$/, 'grep');
  r(/^\/[^/]*\/|^address|^sed\//, 'sed');
  r(/^- - -$/, 'paste');
  r(/^--noreport$/, 'tree');
  r(/^--prune$/, 'find');
  r(/^[ugoa]*[-+=][rwxXst]*(=?[ugo])?$|^X$|^o=g$/, 'chmod');                // ug+w a-wx g= o=g X
  r(/^IFS[=:]/, 'word-splitting');
  r(/^while\/for$/, 'while');
})();
