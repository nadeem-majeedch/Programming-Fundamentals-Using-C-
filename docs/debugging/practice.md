---
title: "Debugging Practice Pack — 20 Broken Programs"
description: "Twenty buggy programs across the whole course — description, expected behaviour, buggy code, hint ladders, corrected code, and explanation."
---

# Practice Pack — 20 broken programs

> [← Module home](index.md) · Four sections of five, ordered by the course's stage system. Each program: **description → expected behaviour → buggy code → hints (escalating) → corrected code → explanation.** The fixes are separated at the bottom of each program — commit to a diagnosis before opening one.

**The deal you make with each program:** read the code until you can *predict the symptom*, then read the expected behaviour to confirm. Hunt with Lesson 1's workflow (reproduce → shrink → hypothesis → cheap test). Use a hint only after forming a hypothesis you tested and abandoned. The [review checklist](lesson-3-better-code.md#6-basic-code-review--reading-code-like-a-reviewer) catches most of these mechanically — run it.

---

## Section 1 — Foundations (P1–P5)

### P1 — The receipt that rounds the wrong way

**Description:** A two-item receipt calculator prints the total of `19.99 + 4.50` as `24` instead of `24.49`.

**Expected behaviour:** `Total: 24.49`.

```cpp
#include <iostream>
using namespace std;
int main() {
    double item1 = 19.99, item2 = 4.50;
    int total = item1 + item2;
    cout << "Total: " << total << "\n";
    return 0;
}
```

**Hints:** 1) Print `item1 + item2` directly — what type is it? 2) Look at the *declared type* of `total` and remember what assignment does to a `double` value stored into an `int`.

<a name="p1-fix"></a>
**Corrected code**

```cpp
#include <iostream>
using namespace std;
int main() {
    double item1 = 19.99, item2 = 4.50;
    double total = item1 + item2;
    cout << "Total: " << total << "\n";
    return 0;
}
```

**Explanation:** `total` is `int`, so the sum is **truncated** (not rounded) to 24 on assignment — an implicit conversion discarding the fraction. The fix keeps money in `double`. (For display control use `<iomanip>`'s `fixed`/`setprecision(2)`; the bug here was storage, not formatting.) Lesson: a wrong *type* in one declaration is a silent logic error — the compiler was never confused, only the programmer.

---

### P2 — The countdown that must count down

**Description:** A five-second launch countdown. **Predict the output before running anything** — write your prediction down, then read the code against it.

**Expected behaviour:** `5 4 3 2 1 Liftoff`.

```cpp
#include <iostream>
using namespace std;
int main() {
    for (int n = 5; n > 0; n--) {
        cout << n << " ";
    }
    cout << "Liftoff\n";
    return 0;
}
```

**Hints:** 1) Which values of n enter the loop body? 2) Does the loop ever print 0? 3) Where does `Liftoff` print relative to the loop?

<a name="p2-fix"></a>
**Corrected code** — unchanged; if your prediction was "the loop skips 0," re-trace: n=5,4,3,2,1 all satisfy `> 0`; the loop exits at n=0 without printing it; `Liftoff` prints after. **Explanation:** the exercise of P2 is metacognition — trace-table discipline applied to your own prediction. When your trace and the code agree but your *expectation* didn't, the expectation was the bug.

---

### P3 — The average that divides too soon

**Description:** The average of marks 80, 90, 70 prints as `0` (should be `80`).

**Expected behaviour:** `Average: 80`.

```cpp
#include <iostream>
using namespace std;
int main() {
    int m1 = 80, m2 = 90, m3 = 70;
    double average = (m1 + m2 + m3) / 3;   // the suspect line
    cout << "Average: " << average << "\n";
    return 0;
}
```

**Hints:** 1) What is `(80 + 90 + 70) / 3` when *everything on the right* is `int`? 2) The division happens **before** the assignment — fixing the declaration type fixes nothing.

<a name="p3-fix"></a>
**Corrected code**

```cpp
#include <iostream>
using namespace std;
int main() {
    int m1 = 80, m2 = 90, m3 = 70;
    double average = (m1 + m2 + m3) / 3.0;   // one double operand makes the division double
    cout << "Average: " << average << "\n";
    return 0;
}
```

**Explanation:** integer division truncates *at the division itself*: `240 / 3` is integer `80` here (a poor example of truncation — change marks to 80, 91, 70 and the buggy version prints 80 while the true average is 80.33). The rule from the Foundations module: **one `double` operand promotes the whole division** (`/ 3.0`, or `static_cast<double>(total) / count`). The classic variant of this bug divides `total` by a `count` declared later as double — the arithmetic, not the storage, is where precision dies.

---

### P4 — The sentinel that joins the data

**Description:** A marks-entry loop should stop at −1 and print the average of the *entered* marks. It crashes (or prints nonsense) — and −1 appears in the average.

**Expected behaviour:** input `80 90 -1` → `Average: 85`.

```cpp
#include <iostream>
using namespace std;
int main() {
    int mark, total = 0, count = 0;
    cout << "Enter marks (-1 to stop): ";
    while (mark != -1) {              // first iteration reads nothing
        cin >> mark;
        total += mark;
        count++;
    }
    cout << "Average: " << total / count << "\n";
    return 0;
}
```

**Hints:** 1) Trace iteration 1: what is `mark` before the first `cin`? 2) When −1 finally *is* read, does the loop body still add it? 3) Two distinct bugs: one uninitialized, one in the add-then-test order.

<a name="p4-fix"></a>
**Corrected code**

```cpp
#include <iostream>
using namespace std;
int main() {
    int mark, total = 0, count = 0;
    cout << "Enter marks (-1 to stop): ";
    cin >> mark;                       // prime read
    while (mark != -1) {
        total += mark;
        count++;
        cin >> mark;                   // read again at the bottom
    }
    if (count > 0)
        cout << "Average: " << static_cast<double>(total) / count << "\n";
    else
        cout << "No marks entered.\n";
    return 0;
}
```

**Explanation:** three repairs. (1) **Uninitialized `mark`** — the condition reads garbage before any input; undefined behaviour that *usually* misbehaves. (2) **The sentinel enters the totals** — the body adds before re-testing; the prime-read + read-at-bottom structure (the Iteration module's "prime read") fixes both by making the condition see each value exactly once, before any use. (3) **Defensive division** — the empty-input case would divide by zero; the guard converts a crash into a message. (The integer-division repair from P3 rides along, because it's the same bug family.)

---

### P5 — The grade with a falling-through floor

**Description:** A grade function returns `B` for 95 and `D` for 85.

**Expected behaviour:** `grade(95)` = A, `grade(85)` = B, `grade(72)` = C.

```cpp
#include <iostream>
using namespace std;
int main() {
    int mark;
    cin >> mark;
    char grade;
    if (mark >= 90)
        grade = 'A';
    else if (mark >= 80)
        grade = 'B';
    else if (mark >= 70)
        grade = 'C';
    cout << grade << "\n";
    return 0;
}
```

For 95 this prints `A`... on most machines. But the *reported* bug says 95 → `B`. Read the hints, then decide what the *real* defect is.

**Hints:** 1) Enter 55 and run it. What prints? 2) What is `grade`'s value when **no branch** fires? 3) The missing case is the bug — the reported 95→B is a *symptom of reading uninitialized memory* on some runs, but the deterministic bug is below 70.

<a name="p5-fix"></a>
**Corrected code**

```cpp
#include <iostream>
using namespace std;
int main() {
    int mark;
    cin >> mark;
    char grade;
    if (mark >= 90)       grade = 'A';
    else if (mark >= 80)  grade = 'B';
    else if (mark >= 70)  grade = 'C';
    else if (mark >= 60)  grade = 'D';
    else                  grade = 'F';
    cout << grade << "\n";
    return 0;
}
```

**Explanation:** the ladder had **no final `else`** — every mark below 70 left `grade` uninitialized and printed garbage. This is the lesson's poster child for defensive completeness: a decision ladder must be **exhaustive**, and the idiom that guarantees exhaustiveness is a terminal `else` (or a final range check that cannot fall through). Bonus discipline: initializing `char grade = 'F';` would have *contained* the bug — defense in depth. The "95 → B on some runs" framing models how uninitialized-value bugs actually present: inconsistently, machine-to-machine, run-to-run.

---

## Section 2 — Control flow (P6–P10)

### P6 — The eof loop that hangs

**Description:** A program sums numbers until end of input. With input `10 20 30` it prints `sum=60` — but with input `10 20 x` it **never prints anything** and never exits.

**Expected behaviour:** `10 20 30` → `sum=60`; `10 20 x` → `sum=30` (or at minimum: the program terminates).

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, sum = 0;
    while (!cin.eof()) {          // suspect line
        cin >> n;
        sum += n;
    }
    cout << "sum=" << sum << "\n";
    return 0;
}
```

**Hints:** 1) `eof()` is a report of the *past* — it becomes true only **after** a read has failed. What does the pre-test check *before* any failed read? 2) A non-numeric token puts the stream in the **fail** state, not the eof state — does the loop condition ever see the failure? 3) What does a failed `cin >> n` do to `n` (C++11 and later) — and to the stream's willingness to read again?

<a name="p6-fix"></a>
**Corrected code**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, sum = 0;
    while (cin >> n) {            // the read IS the condition
        sum += n;
    }
    cout << "sum=" << sum << "\n";
    return 0;
}
```

**Explanation:** the structure is wrong in a way clean input *hides*. `eof()` only turns true **after** a failed read, so the loop always runs one iteration past the last good value. With `10 20 30`: the reads succeed (sum 60), one extra iteration reads past the end — the failed extraction sets `n` to 0 (C++11 zero-on-failure) and adds nothing visible — then eof is true and the loop exits. Correct output, by luck. With `10 20 x`: the `x` puts the stream in the **fail state**, not the eof state; `eof()` stays false forever; every retry of `cin >> n` fails instantly without advancing; `n` stays 0; the loop **spins forever**. The correct structure makes the read itself the condition: `while (cin >> n)` — a stream in a boolean context is false on *any* failure (eof *or* bad token), so both inputs terminate. Every value is tested before use; no state needs predicting. **The meta-lesson:** `while (!stream.eof())` is wrong for exactly the inputs you didn't test — which is why the invalid-input test family exists.

---

### P7 — The triangle that came out square

**Description:** A shape program should print a 4-row left triangle. It prints 4 identical rows of 4.

**Expected behaviour:**

```text
*
**
***
****
```

```cpp
#include <iostream>
using namespace std;
int main() {
    for (int i = 1; i <= 4; i++) {
        for (int j = 1; j <= 4; j++) {   // suspect
            cout << "*";
        }
        cout << "\n";
    }
    return 0;
}
```

**Hints:** 1) What does the inner loop's bound depend on? 2) "Row i has i stars" — which variable is *i* in the code?

<a name="p7-fix"></a>
**Corrected code**

```cpp
#include <iostream>
using namespace std;
int main() {
    for (int i = 1; i <= 4; i++) {
        for (int j = 1; j <= i; j++) {   // bound depends on the outer row
            cout << "*";
        }
        cout << "\n";
    }
    return 0;
}
```

**Explanation:** the inner bound must **depend on the outer variable** (`j <= i`); hardcoding 4 prints a square. The family: "the shape program printed a square/rectangle instead of a triangle" — always an inner bound that forgot the outer row exists. The trace-table fix: one row per outer iteration, inner count written next to it.

---

### P8 — The menu that needs two entries

**Description:** A `do-while` menu prints the menu, reads a choice, acts — then **prints the menu again and waits for another choice before acting on the first**... no: it acts correctly, but the *first* time through it processes a garbage choice and prints "Invalid".

**Expected behaviour:** menu → choice `2` → acts on 2 → menu again. First run must not say "Invalid".

```cpp
#include <iostream>
using namespace std;
int main() {
    int choice = 0;
    do {
        if (choice == 1) cout << "Balance\n";
        else if (choice == 2) cout << "Deposit\n";
        else if (choice == 3) cout << "Quit\n";
        else cout << "Invalid\n";
        cout << "1) Balance 2) Deposit 3) Quit: ";
        cin >> choice;
    } while (choice != 3);
    return 0;
}
```

**Hints:** 1) The body *acts* before it *asks* — what does the first pass act on? 2) The Iteration module called the fix "prime read"; the `do-while` version reorders act/ask.

<a name="p8-fix"></a>
**Corrected code**

```cpp
#include <iostream>
using namespace std;
int main() {
    int choice = 0;
    do {
        cout << "1) Balance 2) Deposit 3) Quit: ";
        cin >> choice;                 // ask FIRST
        if (choice == 1) cout << "Balance\n";
        else if (choice == 2) cout << "Deposit\n";
        else if (choice == 3) cout << "Quit\n";
        else cout << "Invalid\n";
    } while (choice != 3);
    return 0;
}
```

**Explanation:** the original acts-then-asks, so the first pass acts on `choice = 0` → "Invalid" with no user input yet. The corrected ask-then-act processes each choice exactly once, after reading it. (Quit still prints "Quit" once — acceptable; a `switch` with `case 3: return 0;` would suppress it. Same family as P4: **the order of test and use.**)

---

### P9 — The search that reported twice

**Description:** A 3×3 grid holds the target **three times**; the program must report only the **first** match and stop. It reports row 0 — and then row 1, and row 2.

**Expected behaviour:** grid `{ {3,2,7},{5,3,4},{3,9,1}}`, target 3 → exactly one line: `found at row 0 col 0`.

```cpp
#include <iostream>
using namespace std;
int main() {
    int grid[3][3] = { {3, 2, 7}, {5, 3, 4}, {3, 9, 1}};
    int target = 3;
    bool found = false;
    for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
            if (grid[r][c] == target) {
                cout << "found at row " << r << " col " << c << "\n";
                found = true;
                break;                  // suspect
            }
        }
    }
    if (!found) cout << "not found\n";
    return 0;
}
```

**Hints:** 1) Which loop does `break` terminate? 2) After the inner break, what does the outer loop do? 3) The Boolean-flag pattern exists precisely for this; the double-`break` desire needs the flag (or a goto nobody recommends).

<a name="p9-fix"></a>
**Corrected code**

```cpp
#include <iostream>
using namespace std;
int main() {
    int grid[3][3] = { {3, 2, 7}, {5, 3, 4}, {3, 9, 1}};
    int target = 3;
    bool found = false;
    for (int r = 0; r < 3 && !found; r++) {        // the outer condition checks the flag
        for (int c = 0; c < 3; c++) {
            if (grid[r][c] == target) {
                cout << "found at row " << r << " col " << c << "\n";
                found = true;
                break;                              // inner exit only
            }
        }
    }
    if (!found) cout << "not found\n";
    return 0;
}
```

**Explanation:** `break` terminates **only the innermost enclosing loop**; the outer loop's next iteration re-enters and finds the *next* match — reporting rows 1 and 2 despite the "stop at first" contract. The fix makes the outer condition carry the flag (`r < 3 && !found`), so one match ends everything. (An alternative: put the search in a function and `return` — the Functions module's wall, doing its job.) **The trace habit that catches it:** after any `break`, ask "which loop *number* am I leaving?"

---

### P10 — The validator that loops forever

**Description:** Read a percentage 0–100 with validation. Entering `150` correctly re-prompts — but entering `abc` **prints "Invalid" forever** and never asks again.

**Expected behaviour:** `150` → one "Invalid", then re-prompt; `abc` → recover and re-prompt.

```cpp
#include <iostream>
using namespace std;
int main() {
    int pct;
    do {
        cout << "Percentage (0-100): ";
        cin >> pct;
        if (pct < 0 || pct > 100) cout << "Invalid\n";
    } while (pct < 0 || pct > 100);
    cout << "Accepted: " << pct << "\n";
    return 0;
}
```

**Hints:** 1) Trace `150`: invalid → loop re-tests... what value does it re-test with? 2) Trace `abc`: what does a failed `cin >> int` do to `pct` and to the stream? 3) The C++-IO module's mixing-trap section owns this bug.

<a name="p10-fix"></a>
**Corrected code**

```cpp
#include <iostream>
#include <limits>
using namespace std;
int main() {
    int pct;
    do {
        cout << "Percentage (0-100): ";
        if (!(cin >> pct)) {                       // non-numeric: stream failed
            cin.clear();                           // forget the failure
            cin.ignore(numeric_limits<streamsize>::max(), '\n');  // dump the bad line
            cout << "Invalid\n";
            pct = -1;                              // force the loop to continue
            continue;
        }
        if (pct < 0 || pct > 100) cout << "Invalid\n";
    } while (pct < 0 || pct > 100);
    cout << "Accepted: " << pct << "\n";
    return 0;
}
```

**Explanation:** two independent behaviours, one of them fatal. (1) **Out-of-range numbers** (150): the loop handles them correctly — re-prompt, re-read, re-test. (2) **Non-numeric input** (`abc`): a failed extraction puts the stream in the **fail state** — `cin` then ignores *everything* (including new input) until `clear()`, `pct` is left at its old value, the condition re-tests the stale value, and the loop spins printing "Invalid" without ever reading again. The cure is the stream-repair rhythm: **`clear()` then `ignore()` the bad line**, then re-prompt — the C++-IO module's exact recipe. This bug is the reason validation code needs its *own* invalid-input tests: normal tests never execute the stream-repair path.

---

## Section 3 — Functions, arrays, strings (P11–P15)

### P11 — The function that fixed nothing

**Description:** A function is supposed to double the caller's variable. After calling it, the value is unchanged.

**Expected behaviour:** `x = 5` → `doubleIt(x)` → `x = 10`.

```cpp
#include <iostream>
using namespace std;

void doubleIt(int value) {
    value = value * 2;
}

int main() {
    int x = 5;
    doubleIt(x);
    cout << x << "\n";
    return 0;
}
```

**Hints:** 1) What does pass-by-value copy? 2) Which parameter kind writes back to the caller?

<a name="p11-fix"></a>
**Corrected code**

```cpp
#include <iostream>
using namespace std;

void doubleIt(int& value) {   // reference parameter: the caller's box
    value = value * 2;
}
// ...main unchanged...
```

**Explanation:** the parameter is a **copy**; doubling the copy, then destroying it at return, changes nothing the caller can see. `int&` makes the parameter an alias for the caller's `x` — the Functions module's two-names-one-box. The debugging rule of thumb: *a function whose job is to modify the caller's data must take a reference (or pointer); if its output arrives by return instead, the caller must use the return.* Half-doing either is this bug.

---

### P12 — The return that returned before working

**Description:** A function should print all even numbers in 1..n and return how many it printed. It returns 0 — but prints correctly... no: it prints nothing and returns 0.

**Expected behaviour:** `evens(10)` prints `2 4 6 8 10` and returns 5.

```cpp
#include <iostream>
using namespace std;

int evens(int n) {
    int count = 0;
    for (int i = 2; i <= n; i += 2) {
        cout << i << " ";
        count++;
    }
    return 0;        // suspect
}

int main() {
    int k = evens(10);
    cout << "\ncount=" << k << "\n";
    return 0;
}
```

**Hints:** 1) Which value does `return` send — the expression you compute or a literal? 2) The compiler *warned* about this. What did the warning say?

<a name="p12-fix"></a>
**Corrected code**

```cpp
    return count;    // send the computed value, not a placeholder
```

**Explanation:** `return 0;` was scaffolding that never got replaced — the count was computed and dropped. `-Wall` emits "warning: no return statement in function returning non-void" only for *missing* returns; here the return exists, so the compile is clean — the bug ships silently. The habit: after writing any function, **read the last line and ask "what does this hand back?"** This is also the first place the [review checklist](lesson-3-better-code.md#6-basic-code-review--reading-code-like-a-reviewer) pays.

---

### P13 — The array that trusted its caller

**Description:** `fillSquares(arr, n)` should set `arr[i] = i*i`. It works... until the program crashes *later*, in unrelated code, for arrays larger than 10.

**Expected behaviour:** for `n = 12`, all 12 squares set, no crash.

```cpp
void fillSquares(int arr[], int n) {
    for (int i = 0; i < n; i++)
        arr[i] = i * i;
}
// called with:
int squares[10];
fillSquares(squares, 12);    // "12 squares, the array will cope"
```

**Hints:** 1) Whose memory is `arr[10]`? 2) The function is *innocent* — who broke the contract? 3) Defensive fix: where does the capacity live, and who can see it?

<a name="p13-fix"></a>
**Corrected code**

```cpp
const int CAPACITY = 10;                  // one authoritative home (DRY, Lesson 3)

void fillSquares(int arr[], int n) {
    if (n > CAPACITY) n = CAPACITY;       // defensive clamp at the boundary
    for (int i = 0; i < n; i++)
        arr[i] = i * i;
}

int main() {
    int squares[CAPACITY];
    fillSquares(squares, CAPACITY);
    return 0;
}
```

**Explanation:** the array's capacity is 10; `fillSquares(squares, 12)` instructs the function to write `squares[10]` and `squares[11]` — **out of bounds**, into memory that belongs to other variables (or the program). Arrays in C++ carry no length; the parameter *is* the contract, and the caller lied. The defensive answer clamps to the declared capacity (which now lives in one `const` — a name the caller can't mistype). **The larger lesson:** the crash's *location* (unrelated code, later) is the classic out-of-bounds signature — the write corrupted a neighbour and the wound surfaced elsewhere. When a crash's location makes no sense, audit the arrays.

---

### P14 — The comparison that compared addresses

**Description:** A function should report whether two C-strings hold the same text. `sameText("abc", "abc")` prints "different".

**Expected behaviour:** `sameText("abc", "abc")` → `same`.

```cpp
#include <iostream>
using namespace std;

void sameText(const char a[], const char b[]) {
    if (a == b) cout << "same\n";
    else cout << "different\n";
}

int main() {
    char x[] = "abc", y[] = "abc";
    sameText(x, y);
    return 0;
}
```

**Hints:** 1) What *is* an array name in an expression (Pointers module, Lesson 3)? 2) What does `==` compare when the operands are addresses? 3) `std::string` handles this correctly — why, and what does that say about which type to prefer?

<a name="p14-fix"></a>
**Corrected code**

```cpp
#include <iostream>
#include <cstring>
using namespace std;

void sameText(const char a[], const char b[]) {
    if (strcmp(a, b) == 0) cout << "same\n";    // 0 = identical contents
    else cout << "different\n";
}
// main unchanged
```

**Explanation:** array names decay to **addresses**; `a == b` compares *where the strings live*, not what they contain — two separate arrays holding identical text are, correctly, at different addresses, so the test fails. `strcmp` compares character by character (returning 0 when identical). The Strings module's lesson restated as a debugging rule: **`==` on C-strings compares addresses; use `strcmp` — or use `std::string`, where `==` was taught to compare contents.** The one-word prevention: prefer `std::string`.

---

### P15 — The string that grew from the wrong end

**Description:** `reverseStr(s)` should reverse a `std::string` in place. Called on `"abcd"`, it prints an **empty line**.

**Expected behaviour:** `"abcd"` → `"dcba"`.

```cpp
#include <iostream>
#include <string>
using namespace std;

void reverseStr(string& s) {
    int n = s.length();
    for (int i = 0; i < n / 2; i++) {
        char temp = s[i];
        s[i] = s[n - i];          // suspect
        s[n - i] = temp;
    }
}

int main() {
    string t = "abcd";
    reverseStr(t);
    cout << t << "\n";
    return 0;
}
```

**Hints:** 1) The last index of an n-length string is — 2) trace i=0 for "abcd" *character by character* — note that `s[n-0]` reads one slot **past the end**.

<a name="p15-fix"></a>
**Corrected code**

```cpp
void reverseStr(string& s) {
    int n = s.length();
    for (int i = 0; i < n / 2; i++) {
        char temp = s[i];
        s[i] = s[n - 1 - i];      // the mirror of i is n-1-i
        s[n - 1 - i] = temp;
    }
}
```

**Explanation:** the mirror of index `i` in an n-length string is `n − 1 − i` (last index is `n − 1`, not `n`). The original swaps with `s[n − i]` — at `i = 0` that is `s[n]`, **one past the last character**. Reading it yields `'\0'` (the terminator slot), which gets planted at index 0 — and a string whose first byte is `'\0'` prints as **empty**, whatever the rest holds. Writing that slot (the second half of the swap) is undefined behaviour. The off-by-one family again: **bounds first, then swap.** The prevention ritual from the Arrays module — state the valid index range in a comment before writing the loop — catches this before the compiler can't.

---

## Section 4 — Files, records, dynamic memory (P16–P20)

### P16 — The report that opens a door to nowhere

**Description:** A program reads `marks.txt` and prints a summary. When the file is missing, it prints "Average of 0 students: -nan".

**Expected behaviour:** missing file → a clear message and a clean exit.

```cpp
#include <iostream>
#include <fstream>
using namespace std;

int main() {
    ifstream in("marks.txt");
    int mark, total = 0, count = 0;
    while (in >> mark) {
        total += mark;
        count++;
    }
    cout << "Average of " << count << " students: " << (double)total / count << "\n";
    in.close();
    return 0;
}
```

**Hints:** 1) What does a failed `ifstream` constructor do — crash, or something quieter? 2) The read loop is *correct*; what did it correctly read from a door to nowhere? 3) The Files module's four-word discipline.

<a name="p16-fix"></a>
**Corrected code**

```cpp
#include <iostream>
#include <fstream>
using namespace std;

int main() {
    ifstream in("marks.txt");
    if (!in) {                                    // the open-check
        cout << "Error: marks.txt could not be opened.\n";
        return 1;
    }
    int mark, total = 0, count = 0;
    while (in >> mark) {
        total += mark;
        count++;
    }
    if (count > 0)
        cout << "Average of " << count << " students: " << (double)total / count << "\n";
    else
        cout << "File opened but contained no marks.\n";
    return 0;
}
```

**Explanation:** a failed open doesn't crash — the stream just sits in a failed state, every read fails instantly, the loop body never runs, and the program falls through to divide by **zero** and print `-nan`. The original committed the Files module's cardinal sin: **opening without checking**. The fix checks at the door (`if (!in)`) and handles the *other* silent case — a file that opens but is empty — which the original reported as a nonsense average. Both are the same discipline: **every boundary, checked; every division, guarded.**

---

### P17 — The ledger that vanished

**Description:** A program appends today's transactions to `ledger.txt`... but after running it, the file holds only *today's* lines.

**Expected behaviour:** old lines preserved, new lines appended at the end.

```cpp
#include <iostream>
#include <fstream>
using namespace std;

int main() {
    ofstream out("ledger.txt");       // suspect
    out << "2026-09-23 tea 120\n";
    out.close();
    return 0;
}
```

**Hints:** 1) What does a bare `ofstream` constructor *mean* to the existing file? 2) One argument, one word, fixes it — what does that word promise?

<a name="p17-fix"></a>
**Corrected code**

```cpp
#include <iostream>
#include <fstream>
using namespace std;

int main() {
    ofstream out("ledger.txt", ios::app);   // append mode: never truncate
    if (!out) {
        cout << "Error: could not open ledger.txt\n";
        return 1;
    }
    out << "2026-09-23 tea 120\n";
    return 0;
}
```

**Explanation:** a bare `ofstream` **truncates** — the file is emptied the instant it opens, before a single byte is written. The missing `ios::app` is the Files module's most destructive default: the mode is the *contract* ("I promise to add, not destroy"), and its absence is a promise to destroy. (The fix also adds the open-check P16 taught — one repair session, both habits.) The debugging note for real life: this bug is often discovered *by the user*, one semester of data later. Backups and the append-mode habit are the whole defense.

---

### P18 — The field that slid one slot

**Description:** A CSV line `name;mark` is parsed with find/substr/stoi. For `Aisha;87` the program reports name `Aisha` and mark **0**.

**Expected behaviour:** name `Aisha`, mark `87`.

```cpp
#include <iostream>
#include <string>
using namespace std;

int main() {
    string line = "Aisha;87";
    string name = line.substr(0, line.find(';'));
    int mark = stoi(line.substr(line.find(';'), 2));   // suspect
    cout << name << " / " << mark << "\n";
    return 0;
}
```

**Hints:** 1) `substr(start, len)` — what is the second argument? 2) What character sits at `line.find(';')` itself? 3) The Strings module's substr rule: start and **length**, never start and end.

<a name="p18-fix"></a>
**Corrected code**

```cpp
#include <iostream>
#include <string>
using namespace std;

int main() {
    string line = "Aisha;87";
    size_t sep = line.find(';');                      // find once, use twice
    string name = line.substr(0, sep);
    int mark = stoi(line.substr(sep + 1));            // start AFTER the separator; rest of string
    cout << name << " / " << mark << "\n";
    return 0;
}
```

**Explanation:** two bugs in one line. (1) `substr(pos, 2)` starts **at the semicolon** — the slice is `";8"` — and `stoi(";8")` throws `invalid_argument`; with a leading-space variant (`"; 87"`) `stoi` skips the space and returns 8 — either way the field is garbage. (2) The slice must start at `sep + 1`, **past** the separator, with the length omitted (everything to the end). Fixing it once in a named variable (`sep`) also removes the double-search — DRY at line scale. The general debugging rule this teaches: **trace the exact arguments** — `substr` bugs never look like bugs until you evaluate `find` and the arithmetic in the trace.

---

### P19 — The new without a partner

**Description:** A function resizes a dynamic array of scores: allocate bigger, copy, return the new block. Called once with the return used, it works — but every call **leaks the old block**, and a caller who ignores the return sees stale data. Repeated growth eventually exhausts memory.

**Expected behaviour:** repeated growth with no leaks, no stale data, no crashes.

```cpp
int* grow(int* data, int& capacity) {
    int* bigger = new int[capacity * 2];
    for (int i = 0; i < capacity; i++)
        bigger[i] = data[i];
    capacity = capacity * 2;
    data = bigger;            // suspect
    return data;
}
// caller:
//   scores = grow(scores, capacity);   // works
// but somewhere else someone called:
//   grow(scores, capacity);            // ignoring the return!
```

**Hints:** 1) What does `data = bigger;` change — the caller's pointer, or a copy? 2) The `return data;` exists — why does the leak happen only when the return is ignored? 3) The Pointers module's two pointer jobs: re-pointing vs pass-down. Which is this function trying to do, and how many mechanisms does it use?

<a name="p19-fix"></a>
**Corrected code**

```cpp
int* grow(int* data, int& capacity) {
    int* bigger = new int[capacity * 2];
    for (int i = 0; i < capacity; i++)
        bigger[i] = data[i];
    capacity = capacity * 2;
    delete[] data;          // release the old block — the caller's pointer still names it
    return bigger;          // hand back the new block
}
// contract, documented at the declaration:
//   scores = grow(scores, capacity);   // MUST use the return; the old block is gone
```

**Explanation:** the original had **two ownership mechanisms and no release**. `data = bigger;` re-points only the function's local copy (it dies at return); the caller's `scores` still names the **old** block — which nothing ever `delete[]`s: the leak, on *every* call, even well-behaved ones. Callers who ignored the return kept reading the old block: stale data on top of the leak. The fix states one contract: **the function releases the old block and returns the new one; ignoring the return is a bug the comment now names.** (The Quiz Runner used `int*&` — a reference to the pointer — which re-points the caller's variable *and* allows `void`; either design is fine. The bug is two half-mechanisms.) This is the Pointers module's ownership rule wearing its debugging hat: **every `new[]` has exactly one `delete[]`, and one variable whose job is to remember it.**

---

### P20 — The struct copy that fooled the test

**Description:** `graduate(Student s)` should mark a student graduated. After calling it, the roster still shows the student active — but the *unit test passes*.

**Expected behaviour:** after `graduate(roster[3])`, `roster[3].status == GRADUATED`.

```cpp
#include <iostream>
#include <string>
using namespace std;

enum Status { ACTIVE, GRADUATED };

struct Student {
    string name;
    Status status;
};

void graduate(Student s) {        // suspect
    s.status = GRADUATED;
}

int main() {
    Student roster[1] = { {"Aisha", ACTIVE} };
    graduate(roster[0]);
    cout << (roster[0].status == GRADUATED ? "graduated" : "active") << "\n";
    return 0;
}
```

**Hints:** 1) P11's bug, wearing a struct. 2) Which parameter kind reaches the caller's record? 3) The Records module's three doors — value, pointer, reference. Which did this choose?

<a name="p20-fix"></a>
**Corrected code**

```cpp
void graduate(Student& s) {       // reference: the caller's record itself
    s.status = GRADUATED;
}
// ...main unchanged... prints: graduated
```

**Explanation:** structs pass by **value** by default — `graduate` received a *copy*, graduated the copy, and destroyed it at return; the roster never heard about it. ("But the unit test passes" — because the test graduated a copy too, and checked the copy: a test that shares the production bug's blind spot. This is why tests must assert on *the caller's* state.) The fix is P11's lesson at record scale: **mutating functions take references**; the Records module's decision table adds the refinement — read-only visitors take `const&`, and the compiler now enforces the promise. The meta-lesson worth keeping: when "it works in the test but not in the program," hunt for **two different variables that look like one**.

---

## Where next

- [The Debugging Challenge Lab](lab.md): the timed triage and your bug journal's first entries.
- Re-run the [review checklist](lesson-3-better-code.md#6-basic-code-review--reading-code-like-a-reviewer) on your own Project 1 or 2 code — twenty minutes, real findings.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
