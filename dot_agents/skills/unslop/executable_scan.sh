#!/usr/bin/env bash
# unslop scan: deterministic detector for AI writing tells.
#
# Usage: scan.sh FILE...        scan files
#        cat draft.md | scan.sh scan stdin
#
# Reports "path:line: [rule] note" for the patterns a regex can settle.
# Fenced code, indented code, frontmatter, inline code, URLs, and link
# targets are excluded from every check. Patterns that need judgement
# (significance inflation, false ranges, synonym cycling, rule of three)
# are not detected here; see SKILL.md for those.
#
# Hits are findings, not failures: the status is 0 whether or not any are
# reported. A nonzero status means the scan itself failed, such as an
# unreadable file.

set -uo pipefail

if [ "$#" -eq 0 ]; then
  set -- /dev/stdin
fi

LC_ALL=C awk '
function count(s, t,   n, p) {
  n = 0
  while ((p = index(s, t)) > 0) { n++; s = substr(s, p + length(t)) }
  return n
}
function hit(rule, msg) {
  printf "%s:%d: [%s] %s\n", FILENAME, FNR, rule, msg
  hits++
}
function words(s,   i, n, a, c) {
  n = split(s, a, /[ \t]+/)
  c = 0
  for (i = 2; i <= n; i++) if (a[i] ~ /^[A-Z][a-z]+$/) c++
  return c
}

BEGIN {
  APO    = sprintf("%c", 39)
  EMD    = sprintf("%c%c%c", 226, 128, 148)
  LSQ    = sprintf("%c%c%c", 226, 128, 152)
  RSQ    = sprintf("%c%c%c", 226, 128, 153)
  LDQ    = sprintf("%c%c%c", 226, 128, 156)
  RDQ    = sprintf("%c%c%c", 226, 128, 157)
  EMOJI  = sprintf("%c%c", 240, 159)
  DINGA  = sprintf("%c%c", 226, 156)
  DINGB  = sprintf("%c%c", 226, 158)
  DINGC  = sprintf("%c%c", 226, 154)

  strong = "delve|delving|tapestry|testament|pivotal|showcase|showcases|showcasing|underscore|underscores|underscoring|interplay|garner|garnered|myriad|plethora|realm|embark|ever-evolving|ever-changing|game-changer|game-changing|revolutionize|revolutionizing|groundbreaking|breathtaking|nestled|vibrant|renowned|must-visit|seamlessly|meticulous|meticulously|profoundly|indelible|unparalleled|stunning|world-class"
  medium = "additionally|moreover|furthermore|crucial|crucially|enhance|enhances|enhancing|foster|fosters|fostering|leverage|leverages|leveraging|utilize|utilizes|utilizing|robust|holistic|comprehensive|navigate|navigating|elevate|empower|empowers|streamline|streamlines|landscape|intricate|intricacies|enduring|cutting-edge|harness|harnessing|vital|seamless"

  n = 0
  p[++n] = "it is important to note";  r[n] = "filler";      m[n] = "delete the preamble, keep the point"
  p[++n] = "its important to note";    r[n] = "filler";      m[n] = "delete the preamble, keep the point"
  p[++n] = "it is worth noting";       r[n] = "filler";      m[n] = "delete the preamble, keep the point"
  p[++n] = "its worth noting";         r[n] = "filler";      m[n] = "delete the preamble, keep the point"
  p[++n] = "needless to say";          r[n] = "filler";      m[n] = "then do not say it"
  p[++n] = "at the end of the day";    r[n] = "filler";      m[n] = "cut"
  p[++n] = "in order to";              r[n] = "filler";      m[n] = "use \"to\""
  p[++n] = "due to the fact that";     r[n] = "filler";      m[n] = "use \"because\""
  p[++n] = "when it comes to";         r[n] = "filler";      m[n] = "name the subject directly"
  p[++n] = "in the world of";          r[n] = "filler";      m[n] = "cut the scene-setting"
  p[++n] = "in todays";                r[n] = "inflation";   m[n] = "drop the era framing"
  p[++n] = "in an era";                r[n] = "inflation";   m[n] = "drop the era framing"
  p[++n] = "a testament to";           r[n] = "inflation";   m[n] = "state what happened instead"
  p[++n] = "pivotal moment";           r[n] = "inflation";   m[n] = "state what happened instead"
  p[++n] = "evolving landscape";       r[n] = "inflation";   m[n] = "name the actual change"
  p[++n] = "setting the stage";        r[n] = "inflation";   m[n] = "name what follows"
  p[++n] = "indelible mark";           r[n] = "inflation";   m[n] = "state the effect"
  p[++n] = "deeply rooted";            r[n] = "inflation";   m[n] = "state the origin"
  p[++n] = "marks a turning point";    r[n] = "inflation";   m[n] = "state what changed"
  p[++n] = "paradigm shift";           r[n] = "inflation";   m[n] = "describe the shift"
  p[++n] = "plays a crucial role";     r[n] = "inflation";   m[n] = "say what it does"
  p[++n] = "plays a vital role";       r[n] = "inflation";   m[n] = "say what it does"
  p[++n] = "serves as";                r[n] = "copula";      m[n] = "use \"is\""
  p[++n] = "stands as";                r[n] = "copula";      m[n] = "use \"is\""
  p[++n] = "acts as a";                r[n] = "copula";      m[n] = "use \"is\""
  p[++n] = "boasts";                   r[n] = "copula";      m[n] = "use \"has\""
  p[++n] = "is home to";               r[n] = "copula";      m[n] = "use \"has\""
  p[++n] = "experts say";              r[n] = "attribution"; m[n] = "name the source or cut the claim"
  p[++n] = "experts believe";          r[n] = "attribution"; m[n] = "name the source or cut the claim"
  p[++n] = "experts agree";            r[n] = "attribution"; m[n] = "name the source or cut the claim"
  p[++n] = "studies show";             r[n] = "attribution"; m[n] = "cite the study"
  p[++n] = "studies suggest";          r[n] = "attribution"; m[n] = "cite the study"
  p[++n] = "research suggests";        r[n] = "attribution"; m[n] = "cite the research"
  p[++n] = "reports suggest";          r[n] = "attribution"; m[n] = "cite the report"
  p[++n] = "industry reports";         r[n] = "attribution"; m[n] = "cite the report"
  p[++n] = "some critics";             r[n] = "attribution"; m[n] = "name them"
  p[++n] = "many believe";             r[n] = "attribution"; m[n] = "name who"
  p[++n] = "it is widely";             r[n] = "attribution"; m[n] = "name who"
  p[++n] = "could potentially";        r[n] = "hedging";     m[n] = "use \"may\""
  p[++n] = "may potentially";          r[n] = "hedging";     m[n] = "use \"may\""
  p[++n] = "might possibly";           r[n] = "hedging";     m[n] = "use \"might\""
  p[++n] = "it could be argued";       r[n] = "hedging";     m[n] = "make the argument or drop it"
  p[++n] = "somewhat of a";            r[n] = "hedging";     m[n] = "commit or cut"
  p[++n] = "i hope this helps";        r[n] = "chatbot";     m[n] = "remove"
  p[++n] = "let me know if";           r[n] = "chatbot";     m[n] = "remove"
  p[++n] = "feel free to";             r[n] = "chatbot";     m[n] = "remove"
  p[++n] = "happy to help";            r[n] = "chatbot";     m[n] = "remove"
  p[++n] = "great question";           r[n] = "sycophancy";  m[n] = "answer without the compliment"
  p[++n] = "youre absolutely right";   r[n] = "sycophancy";  m[n] = "answer without the compliment"
  p[++n] = "absolutely right";         r[n] = "sycophancy";  m[n] = "answer without the compliment"
  p[++n] = "in conclusion";            r[n] = "conclusion";  m[n] = "end on a fact, not a signpost"
  p[++n] = "the future looks bright";  r[n] = "conclusion";  m[n] = "state specific plans"
  p[++n] = "only time will tell";      r[n] = "conclusion";  m[n] = "state what is actually unknown"
  p[++n] = "while specific details";   r[n] = "cutoff";      m[n] = "find the source or cut the sentence"
  p[++n] = "as of my last";            r[n] = "cutoff";      m[n] = "remove"
  np = n
}

FNR == 1 { fm = 0; fence = 0; if ($0 == "---") fm = 1 }

fm == 1 { if (FNR > 1 && $0 == "---") fm = 0; next }

/^[ \t]*(```|~~~)/ { fence = !fence; next }
fence == 1 { next }
/^(    |\t)[^ \t*+-]/ { next }

{
  line = $0
  gsub(/`[^`]*`/, " ", line)
  gsub(/https?:\/\/[^ )>]*/, " ", line)
  gsub(/\]\([^)]*\)/, "]", line)

  low = tolower(line)
  flat = low
  gsub(APO, "", flat)
  gsub(RSQ, "", flat)
  gsub(/[^a-z0-9 ]/, " ", flat)
  gsub(/  +/, " ", flat)

  # punctuation and characters
  emd = count(line, EMD)
  islist = (line ~ /^[ \t]*([-*+]|[0-9]+[.)])[ \t]/)
  if (emd >= 2)
    hit("em-dash", "more than one em dash on this line")
  else if (emd == 1 && !islist)
    hit("em-dash", "em dash as a connector; use a period, comma, or parentheses")

  if (count(line, LSQ) || count(line, RSQ) || count(line, LDQ) || count(line, RDQ))
    hit("quotes", "curly quotes; use straight quotes")

  if (index(line, EMOJI) || index(line, DINGA) || index(line, DINGB) || index(line, DINGC))
    hit("emoji", "decorative emoji")

  # headings
  if (line ~ /^#+[ ]/) {
    h = line
    sub(/^#+[ ]+/, "", h)
    if (words(h) >= 2) hit("heading", "possible title case; use sentence case")
  }

  # lists and emphasis
  if (line ~ /^[ \t]*([-*+]|[0-9]+[.)])[ \t]+\*\*[^*]+(:\*\*|\*\*:)/) {
    tail = line
    sub(/^[^*]*\*\*[^*]+(:\*\*|\*\*:)[ \t]*/, "", tail)
    if (tail ~ /\.[ \t]*$/ || split(tail, junk, /[ \t]+/) >= 8)
      hit("inline-header", "sentence hiding behind a bold label; convert to prose")
  }
  if (count(line, "**") >= 6)
    hit("boldface", "three or more bold spans on one line")

  # phrases
  for (i = 1; i <= np; i++)
    if (index(flat, p[i])) hit(r[i], "\"" p[i] "\": " m[i])

  # negative parallelism
  if (low ~ /(not|isn.t|aren.t|it.s not) (just|only|merely)[^.;:]{0,80}(, ?but|; ?but| but it| it.s)/)
    hit("parallelism", "\"not just X, it is Y\"; state the point directly")

  # superficial participles
  if (low ~ /, (highlighting|ensuring|reflecting|showcasing|underscoring|emphasizing|demonstrating|solidifying|cementing|allowing for|making it) /)
    hit("participle", "trailing -ing clause adds no information; cut or replace with a fact")

  # vocabulary
  s = low
  while (match(s, "(^|[^a-z-])(" strong ")([^a-z-]|$)")) {
    w = substr(s, RSTART, RLENGTH)
    gsub(/[^a-z-]/, "", w)
    hit("vocab", "\"" w "\" is an AI tell; use a plain word")
    s = substr(s, RSTART + RLENGTH)
  }
  s = low
  while (match(s, "(^|[^a-z-])(" medium ")([^a-z-]|$)")) {
    w = substr(s, RSTART, RLENGTH)
    gsub(/[^a-z-]/, "", w)
    hit("vocab?", "\"" w "\" is often padding; keep only if it carries weight")
    s = substr(s, RSTART + RLENGTH)
  }

  # mid-sentence colon
  if (line !~ /:[ \t]*$/ && line ~ /[a-z]: [a-z]/ && line !~ /^[ \t]*([-*+]|[0-9]+[.)])[ \t]/)
    hit("colon?", "mid-sentence colon; let the point stand without the setup")
}

END {
  if (hits == 0) printf "no deterministic hits\n"
  else printf "%d deterministic hits\n", hits
}
' "$@"
