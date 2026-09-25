---
title: "Strings Challenges"
description: "10 design challenges — validators, ciphers, formatters, parsers — with separated approach solutions."
---

# Strings Challenges (10)

> [← Module home](index.md) · Attempt **30 minutes** before reading any solution. Challenges combine several tools — sketch the pipeline (read → validate → transform → report) before coding. Solutions separated at the end; each gives the *approach* plus the key code.

---

## C1 — The palindrome judge (★★)

Write a program that reads lines until an empty one and reports for each whether it is a palindrome **ignoring case and non-letters**. So `"A man, a plan, a canal: Panama"` → **yes**, `"hello"` → **no**, `""` ends the loop.

Requirements: normalize first (letters only, lowercase) into a working copy; palindrome-check the copy; preserve the original for display. Test: the Panama line, `"racecar"`, `"12321"`, `"Was it a car or a cat I saw?"`.

## C2 — The word reverser (★★)

Read a sentence and print it with each word reversed but word order and spacing structure kept: `"hello world"` → `"olleh dlrow"`. Must handle multiple spaces gracefully (structure preserved: `"a  b"` → `"a  b"` reversed-words = `"a  b"` with a,b flipped). Hint: walk word-by-word, not char-by-char — build words, reverse each, rejoin.

## C3 — The Caesar both ways (★★)

Extend [E24](exercises.md#s24--caesar): a menu program with **encrypt** (shift +k), **decrypt** (shift −k), and **brute force** (try all 26 shifts on a ciphertext, print all 26 candidates). Decryption = encryption with `26 - k` — prove it with `"khoor"` shifted back 3 → `"hello"`. Brute force is the classic codebreaking demo — for `"khoor"` one of the 26 lines reads `hello`.

## C4 — The title formatter (★★)

Normalize a name/title to headline case: every word capitalized, but small words (`a, an, the, and, or, of, in, on`) lowercase — *unless* first or last word. `"the lord of the rings"` → `"The Lord of the Rings"`. Pipeline: lowercase-all → walk words → capitalize non-small (or first/last). Test: `"war and peace"`, `"the ` `end"` — double spaces must not crash it.

## C5 — The CSV field counter (★★★)

Read lines of comma-separated fields (names only, no commas inside fields) and report per line: number of fields, longest field, and the shortest. `"ali,ayesha,zain"` → 3 fields, longest `ayesha` (7). Handle: trailing comma (`"a,b,"` → 3 fields, last is empty — count it honestly), empty line (0 fields), a line that is just `","` (2 empty fields). No `vector` needed — stream the fields with `find(',')` + `substr`, one at a time.

## C6 — The duplicate-word spotter (★★★)

Read a line; report the first word that appears **twice anywhere in the line** (case-insensitive), or "none". `"The cat and the hat"` → `the` (position 3). Strategy: for each word (extract with the C5/C7 splitting technique), search the *rest* of the line case-insensitively for a second occurrence. Keep it O(n²) — clarity first.

## C7 — The field-splitter generalization (★★★)

Write `int split(const std::string& line, char sep, std::string out[], int maxOut)` — fills `out` with the fields, returns the count (arrays as function params from [Unit 09](../arrays/lesson-3-arrays-functions.md)). Handles: consecutive separators (empty fields), leading/trailing separators, `maxOut` overflow (return −1, or count anyway and don't write past — document the policy). This is the tool Lab 7 and the toolkit's next stage will want. Test: `"a,,b"` → 3 fields (middle empty), `"a,b,c,d"` with maxOut 2 → documented behaviour.

## C8 — The sentence case fixer (★★★)

Text arrives as `"HELLO there. HOW are you? i AM FINE."` — fix sentence case: sentence starts (after `.`, `!`, `?`, or at position 0) uppercase, everything else lowercase. → `"Hello there. How are you? I am fine."` State machine again: `atStart` flag set true initially and after each terminator; letters flip accordingly. Spaces, terminators, digits pass through untouched. Test the `i AM` → `I am` special case... or document why you skip it (a truly complete solution uppercases standalone `i` — attempt it as an extension).

## C9 — The run-length encoder (★★★)

Encode text as letter+count runs: `"aaabbbcccc"` → `"a3b3c4"`. Runs of 1 stay bare: `"abc"` → `"abc"`. Then write the **decoder**: `"a3b3c4"` → `"aaabbbcccc"`, bare letters expand to themselves. Round-trip property: `decode(encode(s)) == s` — test it on 6 strings including `""`, `"a"`, `"abab"`. This is data compression's baby picture — and a perfect build-new drill.

## C10 — The blank-line paragraph splitter (★★★)

Read all lines; paragraphs are separated by blank lines. Output: paragraph count, per-paragraph line counts, and the longest paragraph (by total chars). Also **trim** each paragraph's edge spaces when reporting its first/last line. This is the toolkit's report-builder in miniature — pipeline: state machine over lines (in-paragraph vs between), accumulate per-paragraph stats, emit at transitions.

---

<a name="solutions"></a>
# Solutions (approaches + key code)

<details markdown="1"><summary>C1 — Palindrome judge</summary>

**Approach.** Per line: build `clean` (lowercased letters only — cctype filter), compare `clean` with its reverse (backward traversal + `+=`), report on the *original*.

```cpp
std::string clean;
for (int i = 0; i < line.length(); i = i + 1)
    if (isalpha(line[i])) clean += tolower(line[i]);
std::string rev;
for (int i = clean.length() - 1; i >= 0; i = i - 1) rev += clean[i];
std::cout << line << " -> " << (clean == rev && !clean.empty() ? "YES" : "NO") << '\n';
```
Empty line terminates the read-loop (sentinel). Panama: letters = `amanaplanacanalpanama` — palindrome ✓. `"12321"` → no letters → `clean` empty → NO (document the policy: no letters = not a palindrome... or accept digit-palindromes by relaxing the filter to `isalnum` — a one-word change, choose and document).
</details>

<details markdown="1"><summary>C2 — Word reverser</summary>

**Approach.** State machine over chars: accumulate a word (non-space run), on space-or-end reverse the accumulated word into the output, emit the space verbatim. Multiple spaces: no word between them — the verbatim space handles it.

```cpp
std::string word, out;
for (int i = 0; i <= line.length(); i = i + 1) {
    if (i == line.length() || isspace(line[i])) {
        for (int j = word.length() - 1; j >= 0; j = j - 1) out += word[j];
        word = "";
        if (i < line.length()) out += line[i];   // keep the space
    } else {
        word += line[i];
    }
}
```
The `i == length()` virtual-space flushes the final word — the classic "process the last group" trick. `"a  b"` → two verbatim spaces preserved ✓.
</details>

<details markdown="1"><summary>C3 — Caesar both ways</summary>

**Approach.** One shift function used by all three options. Decrypt: shift by `(26 - k) % 26`. Brute force: loop k = 0..25, encrypt the ciphertext with each, print.

```cpp
std::string shiftBy(const std::string& text, int k) {
    std::string out;
    for (int i = 0; i < text.length(); i = i + 1) {
        char c = text[i];
        if (islower(c))      c = (c - 'a' + k + 26) % 26 + 'a';
        else if (isupper(c)) c = (c - 'A' + k + 26) % 26 + 'A';
        out += c;
    }
    return out;
}
// decrypt: shiftBy(text, 26 - k);   brute: for (int k = 0; k < 26; k = k + 1) ...
```
The `+ 26` before `%` keeps negative shifts safe (C++ `%` of a negative can be negative — this sidesteps it). `"khoor"` − 3 → `hello` ✓; brute force prints all 26, `hello` among them.
</details>

<details markdown="1"><summary>C4 — Title formatter</summary>

**Approach.** Lowercase everything; walk words (C2's state machine); capitalize a word if it's not small OR it's the first/last word. Track word index (or first/last flags).

```cpp
bool isSmall(const std::string& w) {
    std::string small[] = {"a","an","the","and","or","of","in","on"};
    for (int i = 0; i < 8; i = i + 1) if (w == small[i]) return true;
    return false;
}
// per word: if (!isSmall(w) || firstWord || lastWord) w[0] = toupper(w[0]);
```
First/last words need either their indices (count words first — a pre-pass) or: apply after building all words in an array ([Unit 09](../arrays/lesson-1-basics.md) style), where indices 0 and count−1 are known. `"war and peace"` → `War and Peace` ✓ (and is small, middle position). Double spaces: the state machine skips empty words — no crash.
</details>

<details markdown="1"><summary>C5 — CSV field counter</summary>

**Approach.** Per line: stream fields with find/substr — `p = find(',')`; field = substr(0, p); rest = substr(p+1); repeat until npos. Track count/max/min as you go.

```cpp
std::string rest = line; int count = 0;
int maxLen = -1, minLen = 1 << 30;
std::string maxF = "", minF = "";
while (true) {
    std::size_t p = rest.find(',');
    std::string field = (p == std::string::npos) ? rest : rest.substr(0, p);
    // update count, maxLen/maxF, minLen/minF with field ...
    count += 1;
    if (p == std::string::npos) break;
    rest = rest.substr(p + 1);
}
```
`"a,b,"` → fields `a`, `b`, `` → **3** (the trailing comma ends a field — count it). `""` → the loop still runs once with field `""` → 1... *policy*: report empty line as **0 fields** with a pre-guard (`if (line.empty())`). `","` → 2 empty fields ✓.
</details>

<details markdown="1"><summary>C6 — Duplicate-word spotter</summary>

**Approach.** Extract words into an array (C7's splitter, space separator); normalize each to lowercase; for each word i, scan words i+1.. for a match; first hit wins.

```cpp
// words[] from split(); lowercased in place
int found = -1;
for (int i = 0; i < n && found == -1; i = i + 1)
    for (int j = i + 1; j < n; j = j + 1)
        if (words[i] == words[j]) { found = i; break; }
```
`"The cat and the hat"` → lowercased `the,cat,and,the,hat` → words[0] `the` matches words[3] → report `the`. Case-insensitive because of the lowercase pass — [D2's normalize-then-compare](debugging.md#d2--never-equal-no-matter-what-you-type-compare) at array scale.
</details>

<a name="c7"></a>
<details markdown="1"><summary>C7 — Field splitter</summary>

**Approach.** Walk with find; store into `out[]`; guard `maxOut` (don't write past capacity — count fields even when the array is full, per the documented policy).

```cpp
int split(const std::string& line, char sep, std::string out[], int maxOut) {
    int count = 0;
    std::string rest = line;
    while (true) {
        std::size_t p = rest.find(sep);
        std::string field = (p == std::string::npos) ? rest : rest.substr(0, p);
        if (count < maxOut) out[count] = field;
        count += 1;
        if (p == std::string::npos) break;
        rest = rest.substr(p + 1);
    }
    return count;   // caller compares count vs maxOut for overflow
}
```
Policy: the function *always* returns the true field count; it writes only the first `maxOut`. Caller: `if (count > maxOut) /* overflow handling */`. `"a,,b"` → 3 fields (`a`, ``, `b`) ✓. This generalizes C5 and powers Lab 7 — and the same signature pattern (array + capacity + count) is [Unit 09's convention](../arrays/lesson-3-arrays-functions.md#3-the-size-travels-separately--and-how).
</details>

<details markdown="1"><summary>C8 — Sentence case fixer</summary>

**Approach.** Build-new state machine: `atStart = true`; per char — if terminator (`.!?`) set atStart and emit verbatim; if letter: emit upper if atStart else lower, clear atStart; else emit verbatim.

```cpp
bool atStart = true;
for (int i = 0; i < text.length(); i = i + 1) {
    char c = text[i];
    if (c == '.' || c == '!' || c == '?') { atStart = true; out += c; }
    else if (isalpha(c)) {
        out += atStart ? toupper(c) : tolower(c);
        atStart = false;
    } else out += c;
}
```
Input `"HELLO there. HOW are you? i AM FINE."` → `Hello there. How are you? I am fine.` — wait: `i` after `? ` is a sentence start → uppercased to `I` **automatically** — the standalone-`i` case handles itself here because `i AM` opens the sentence. (A standalone mid-sentence `i` — `"what am i doing"` — would need the extension: also uppercase when the previous non-space char run is just `i` bounded by spaces. Attempt it.) Leading spaces before a sentence start don't break it: atStart survives non-letters.
</details>

<details markdown="1"><summary>C9 — Run-length encoder/decoder</summary>

**Approach.** Encode: state machine — track current run char and count; on change-or-end, emit `c` (+ count if > 1). Decode: walk; digit = count multiplier for the *previous* letter; letter = emit immediately (count 1 pending).

```cpp
// encode (core)
std::string out;
char cur = 0; int run = 0;
for (int i = 0; i <= s.length(); i = i + 1) {
    if (i < s.length() && s[i] == cur) { run += 1; }
    else {
        if (run == 1) out += cur;
        else if (run > 1) { out += cur; out += std::to_string(run); }
        if (i < s.length()) { cur = s[i]; run = 1; }
    }
}
```
The virtual-end step (`i == s.length()`) flushes the final run; `cur = 0` can never match a real char, so the first letter always starts a fresh run.

```cpp
// decode (core)
std::string out; char last = 0;
for (int i = 0; i < t.length(); i = i + 1) {
    if (isdigit(t[i])) {
        int n = t[i] - '0';
        for (int j = 0; j < n - 1; j = j + 1) out += last;  // n-1: first already emitted
    } else { out += t[i]; last = t[i]; }
}
```
Multi-digit counts (`a12`) need a digit-run accumulator — the extension. Round-trip on `""`, `"a"`, `"abab"`, `"aaabbbcccc"` ✓. (Single digits only in the base version — document it.)
</details>

<details markdown="1"><summary>C10 — Paragraph splitter</summary>

**Approach.** Read lines in a sentinel loop (empty line ends input); `inPara` state machine: blank line → close paragraph (emit stats, reset accumulators); content line → add to current paragraph's line-count and char-total. End of input closes the final paragraph. Track longest by char-total; remember its first/last lines (trim with a helper that strips edge spaces — or report `line.substr(first non-space, last non-space + 1)` bounds).

```cpp
// per content line:
paraLines += 1; paraChars += line.length();
if (paraLines == 1) firstLine = line;    // no trim needed for counting
lastLine = line;
// per blank line / EOF: emit paraLines, paraChars; if paraChars > best: best = paraChars...
```
Trim for display: find first/last non-space, `substr` between. Empty *input* → 0 paragraphs (guard the final emit). This is the state-machine-over-lines pattern — the same one C2/C8 used over chars, one level up.
</details>
