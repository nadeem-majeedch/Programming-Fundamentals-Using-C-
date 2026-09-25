---
title: "Practice Bank — Challenge Tier (40 problems)"
description: "C-01…C-40: OOP systems, STL, exceptions, integrated problems, and cross-topic challenges — each with statement, difficulty, topics, I/O, constraints, samples, hints, reference solution, and explanation."
---

# Challenge tier — C-01 to C-40

> **Units first:** [Stage E — Memory & objects](../syllabus.md#stage-e-memory-and-objects-units-13-15) and [Stage F — Capstone](../syllabus.md#stage-f-capstone-unit-16), plus the advanced modules (STL, exceptions) — and everything before them.
> **Attempt protocol:** unchanged. At this tier the explanation often names *the design decision* — read it even after a correct solution.

## Part 1 — OOP systems (C-01…C-06)

### C-01 — Shape hierarchy with polymorphic area

**Difficulty:** ★★★ · **Topics:** OOP, inheritance, virtual functions

Build `Shape` (abstract: pure virtual `double area() const`), with `Circle` and `Rectangle` derived. Read commands `c r` / `r w h` until `e`; store each created shape by `Shape*` in an array (max 20); on `e`, print every shape's area (two decimals) then the total. Delete all shapes before exit.

**Input:** command lines ending with `e`.
**Output:** per-shape areas then `total: T`.
**Sample tests:** `c 2` `r 3 4` `e` → `12.57` / `12.00` / `total: 24.57`
**Hints:** ① a pure virtual makes Shape abstract — you can't instantiate it, only point at derived objects; ② one loop over `Shape*` calls the right `area()` each time.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;

class Shape {
public:
    virtual double area() const = 0;     // pure virtual: Shape is abstract
    virtual ~Shape() {}                  // virtual destructor: safe delete through base*
};

class Circle : public Shape {
    double r;
public:
    Circle(double r_) : r(r_) {}
    double area() const { return 3.14159265358979 * r * r; }
};

class Rectangle : public Shape {
    double w, h;
public:
    Rectangle(double w_, double h_) : w(w_), h(h_) {}
    double area() const { return w * h; }
};

int main() {
    Shape* shapes[20];
    int n = 0;
    string cmd;
    while (cin >> cmd && cmd != "e") {
        if (cmd == "c") { double r; cin >> r; shapes[n++] = new Circle(r); }
        else if (cmd == "r") { double w, h; cin >> w >> h; shapes[n++] = new Rectangle(w, h); }
    }
    double total = 0;
    cout << fixed << setprecision(2);
    for (int i = 0; i < n; i++) {
        double a = shapes[i]->area();    // runtime dispatch picks the derived version
        cout << a << "\n";
        total += a;
    }
    cout << "total: " << total << "\n";
    for (int i = 0; i < n; i++) delete shapes[i];
    return 0;
}
```

**Explanation:** the polymorphic collection — one base-pointer array, one loop, many behaviors — is *the* pattern inheritance exists for. The virtual destructor is not decoration: deleting through `Shape*` without it would skip the derived cleanup. *Distinct idea:* one loop, many types.

---

### C-02 — Account family with overridden withdrawal rules

**Difficulty:** ★★★ · **Topics:** OOP, inheritance, overriding

Design `class Account` (protected balance; `virtual bool withdraw(long long amt)` — allows up to balance). Derive `SavingsAccount` (withdraw only if ≥ 1000 remains after) and `CurrentAccount` (allows overdraft down to −50000). Read commands `s`/`c` (create), then `D amt`/`W amt`/`Q` applied to the latest account; print verdicts and the final balance.

**Input:** account type letter, then commands ending with `Q`.
**Output:** verdicts per command, then `balance: B`.
**Sample tests:** `s` `D 5000` `W 4200` `W 100` `Q` → `ok` / `ok` / `denied` / `balance: 800` (4200 left 800 < 1000 floor)
**Hints:** ① protected lets derived classes see balance without exposing it; ② each rule is a small override of one virtual.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

class Account {
protected:
    long long balance = 0;
public:
    void deposit(long long amt) { if (amt > 0) balance += amt; }
    virtual bool withdraw(long long amt) {
        if (amt <= 0 || amt > balance) return false;
        balance -= amt;
        return true;
    }
    long long getBalance() const { return balance; }
    virtual ~Account() {}
};

class SavingsAccount : public Account {
public:
    bool withdraw(long long amt) {
        if (amt <= 0 || balance - amt < 1000) return false;  // the floor rule
        balance -= amt;
        return true;
    }
};

class CurrentAccount : public Account {
public:
    bool withdraw(long long amt) {
        if (amt <= 0 || balance - amt < -50000) return false; // overdraft rule
        balance -= amt;
        return true;
    }
};

int main() {
    string kind;
    cin >> kind;
    Account* acc = (kind == "s") ? static_cast<Account*>(new SavingsAccount())
                                 : static_cast<Account*>(new CurrentAccount());
    string cmd;
    while (cin >> cmd && cmd != "Q") {
        long long amt;
        cin >> amt;
        if (cmd == "D") { acc->deposit(amt); cout << "ok\n"; }
        else cout << (acc->withdraw(amt) ? "ok" : "denied") << "\n";
    }
    cout << "balance: " << acc->getBalance() << "\n";
    delete acc;
    return 0;
}
```

**Explanation:** one deposit inherited unchanged, one withdraw overridden three ways — the Open/Closed idea in miniature: adding an account *kind* means adding a class, not editing the loop. The floor/overdraft samples prove each override actually differs. *Distinct idea:* rules as overridden behavior.

---

### C-03 — Library items with a shared checkout interface

**Difficulty:** ★★★ · **Topics:** OOP, interfaces as design, composition of behavior

Design an abstract `LibraryItem` (title; pure virtual `int loanDays() const`; concrete `checkoutReport()` that prints `title: N days` calling the virtual). Derive `Book` (14 days), `Magazine` (3 days), `Reference` (0 days → checkoutReport must print `title: NOT LOANABLE` — override checkoutReport only in Reference). Read item lines `b title` / `m title` / `r title` until `done`; print each report.

**Input:** item lines ending with `done`.
**Output:** one report line per item.
**Sample tests:** `b C++Primer` `m Time` `r Encyclopedia` `done` → `C++Primer: 14 days` / `Time: 3 days` / `Encyclopedia: NOT LOANABLE`
**Hints:** ① most derived classes inherit the concrete reporter unchanged; ② only Reference overrides it — minimal override surface.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

class LibraryItem {
    string title;
public:
    LibraryItem(string t) : title(t) {}
    string getTitle() const { return title; }
    virtual int loanDays() const = 0;
    virtual void checkoutReport() const {
        cout << getTitle() << ": " << loanDays() << " days\n";
    }
    virtual ~LibraryItem() {}
};

class Book : public LibraryItem {
public:
    Book(string t) : LibraryItem(t) {}
    int loanDays() const { return 14; }
};

class Magazine : public LibraryItem {
public:
    Magazine(string t) : LibraryItem(t) {}
    int loanDays() const { return 3; }
};

class Reference : public LibraryItem {
public:
    Reference(string t) : LibraryItem(t) {}
    int loanDays() const { return 0; }
    void checkoutReport() const { cout << getTitle() << ": NOT LOANABLE\n"; }
};

int main() {
    string kind;
    while (cin >> kind && kind != "done") {
        string title;
        cin >> title;
        LibraryItem* it = nullptr;
        if (kind == "b") it = new Book(title);
        else if (kind == "m") it = new Magazine(title);
        else if (kind == "r") it = new Reference(title);
        if (it) { it->checkoutReport(); delete it; }
    }
    return 0;
}
```

**Explanation:** the interface is `loanDays` plus a *default* report that composes it — derived classes supply data-shaped differences, not boilerplate. Reference's override is the exception path; overriding only where behavior truly differs is the design taste being trained. *Distinct idea:* default behavior with narrow overrides.

---

### C-04 — Payroll hierarchy with polymorphic pay

**Difficulty:** ★★★ · **Topics:** OOP, inheritance, virtual functions, arithmetic

Abstract `Employee` (name; pure virtual `long long monthlyPay() const`). Derive `Salaried` (fixed monthly), `Hourly` (rate × hours, capped at 200 hours), `Commission` (base + 5% of sales). Read n, then n employee lines: `s name amount` / `h name rate hours` / `c name base sales`; print each name's pay, then the total payroll.

**Input:** n (1–20), then employee lines.
**Output:** `name: pay` lines then `payroll: T`.
**Sample tests:** n=3 `s Ayesha 80000` `h Bilal 500 180` `c Sara 20000 100000` → `Ayesha: 80000` / `Bilal: 90000` / `Sara: 25000` / `payroll: 195000`
**Hints:** ① the cap is a min() inside Hourly's pay; ② one base-pointer loop computes everything.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <iomanip>
#include <algorithm>
using namespace std;

class Employee {
public:
    virtual long long monthlyPay() const = 0;
    virtual ~Employee() {}
};

class Salaried : public Employee {
    long long monthly;
public:
    Salaried(long long m) : monthly(m) {}
    long long monthlyPay() const { return monthly; }
};

class Hourly : public Employee {
    long long rate, hours;
public:
    Hourly(long long r, long long h) : rate(r), hours(h) {}
    long long monthlyPay() const { return rate * min(hours, 200LL); }
};

class Commission : public Employee {
    long long base, sales;
public:
    Commission(long long b, long long s) : base(b), sales(s) {}
    long long monthlyPay() const { return base + sales / 20; }   // 5%
};

int main() {
    int n;
    cin >> n;
    Employee* staff[20];
    string names[20];
    for (int i = 0; i < n; i++) {
        string kind, name;
        cin >> kind >> name;
        names[i] = name;
        if (kind == "s") { long long m; cin >> m; staff[i] = new Salaried(m); }
        else if (kind == "h") { long long r, h; cin >> r >> h; staff[i] = new Hourly(r, h); }
        else { long long b, s; cin >> b >> s; staff[i] = new Commission(b, s); }
    }
    long long total = 0;
    for (int i = 0; i < n; i++) {
        long long p = staff[i]->monthlyPay();
        cout << names[i] << ": " << p << "\n";
        total += p;
        delete staff[i];
    }
    cout << "payroll: " << total << "\n";
    return 0;
}
```

**Explanation:** three pay formulas behind one virtual call — and each formula carries its own business rule (the hour cap, the 5% commission) local to its class. Parallel arrays for names beside base pointers is the pragmatic shape at this scale; a struct-of-both is the stated extension. *Distinct idea:* business rules encapsulated per type.

---

### C-05 — University object graph: Departments own Courses

**Difficulty:** ★★★ · **Topics:** OOP, composition, object graphs

Design `Course` (code, credit hours) and `Department` (name, up to 10 Course objects *by value* — composition). Build two departments from input: `dept name` starts one, `course code ch` adds to the latest, `end` finishes it. After all input, print each department with its course list and total credit hours.

**Input:** lines as described, ending with `finish`.
**Output:** per-department blocks: `name (T ch)` then `  code ch` lines.
**Sample tests:** `dept CS` `course CS101 3` `course CS201 4` `end` `dept Math` `course M101 3` `end` `finish` → `CS (7 ch)` / `  CS101 3` / `  CS201 4` / `Math (3 ch)` / `  M101 3`
**Hints:** ① the department owns its courses — no pointers needed, plain member arrays; ② track the "current" department index while reading.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

class Course {
public:
    string code;
    int ch;
    Course() : ch(0) {}
    Course(string c, int h) : code(c), ch(h) {}
};

class Department {
public:
    string name;
    Course courses[10];
    int count = 0;
    int totalCh() const {
        int t = 0;
        for (int i = 0; i < count; i++) t += courses[i].ch;
        return t;
    }
};

int main() {
    Department depts[10];
    int dn = 0, cur = -1;
    string word;
    while (cin >> word && word != "finish") {
        if (word == "dept") { cin >> depts[dn].name; cur = dn; dn++; }
        else if (word == "course" && cur >= 0) {
            string code; int ch;
            cin >> code >> ch;
            depts[cur].courses[depts[cur].count++] = Course(code, ch);
        }
        // "end" needs no action: the next dept just moves the current index
    }
    for (int d = 0; d < dn; d++) {
        cout << depts[d].name << " (" << depts[d].totalCh() << " ch)\n";
        for (int c = 0; c < depts[d].count; c++)
            cout << "  " << depts[d].courses[c].code << " " << depts[d].courses[c].ch << "\n";
    }
    return 0;
}
```

**Explanation:** composition without pointers — a Department *contains* Courses by value, so lifetimes are automatic and no ownership question ever arises. The whole graph is built and printed with zero `new`: the quiet argument that not every relationship needs dynamic allocation. *Distinct idea:* value-owned object graphs.

---

### C-06 — Fraction class with the full operator set

**Difficulty:** ★★★ · **Topics:** OOP, operator overloading, class design

Design `class Fraction` (numerator, denominator as long long; constructor reduces via GCD and rejects zero denominators by storing 0/1). Provide `+`, `*`, `==`, `<`, and `<<`. Read two fractions as `n/d n/d`, print `a+b`, `a*b`, whether `a<b`, in that order.

**Input:** four integers: n1 d1 n2 d2 (denominators nonzero).
**Output:** three lines: sum, product, `true`/`false`.
**Sample tests:** `1 2 1 3` → `5/6` / `1/6` / `true`
**Hints:** ① sum = a·d + b·c over c·d, then reduce; ② `<` via cross-multiplication (watch signs — denominators are kept positive by reduction of the sign into the numerator).
**Reference solution**

```cpp
#include <iostream>
using namespace std;

long long gcdLL(long long a, long long b) {
    while (b != 0) { long long r = a % b; a = b; b = r; }
    return a;
}

class Fraction {
    long long num, den;
    void reduce() {
        long long g = gcdLL(num < 0 ? -num : num, den);
        if (g == 0) g = 1;
        num /= g; den /= g;
        if (den < 0) { den = -den; num = -num; }
    }
public:
    Fraction(long long n = 0, long long d = 1) : num(n), den(d == 0 ? 1 : d) { reduce(); }
    long long getNum() const { return num; }
    long long getDen() const { return den; }
};

Fraction operator+(const Fraction& a, const Fraction& b) {
    return Fraction(a.getNum() * b.getDen() + b.getNum() * a.getDen(),
                    a.getDen() * b.getDen());
}

Fraction operator*(const Fraction& a, const Fraction& b) {
    return Fraction(a.getNum() * b.getNum(), a.getDen() * b.getDen());
}

bool operator==(const Fraction& a, const Fraction& b) {
    return a.getNum() == b.getNum() && a.getDen() == b.getDen();
}

bool operator<(const Fraction& a, const Fraction& b) {
    return a.getNum() * b.getDen() < b.getNum() * a.getDen();
}

ostream& operator<<(ostream& os, const Fraction& f) {
    return os << f.getNum() << "/" << f.getDen();
}

int main() {
    long long n1, d1, n2, d2;
    cin >> n1 >> d1 >> n2 >> d2;
    Fraction a(n1, d1), b(n2, d2);
    cout << (a + b) << "\n" << (a * b) << "\n"
         << (a < b ? "true" : "false") << "\n";
    return 0;
}
```

**Explanation:** the operator family built the course's way — `+` and `*` as free functions (symmetry), `==` as reduced-form equality, `<` by cross-multiplication with the sign normalized into the numerator at construction. GCD-driven reduction makes equality structurally honest: 1/2 == 2/4 because both store as 1/2. *Distinct idea:* normalization enables simple operators.

---

## Part 2 — STL systems (C-07…C-14)

### C-07 — vector to-do list

**Difficulty:** ★★ · **Topics:** STL, vector, menus

Maintain a to-do list in a `vector<string>`. Commands: `add task`, `done N` (erase 1-based item N), `show`, `q`. On `show`, print items numbered; on `q`, print `items left: K`.

**Input:** commands ending with `q`.
**Output:** as specified.
**Sample tests:** `add buy milk` — wait, tasks may contain spaces: read the whole rest of the line with getline after the command word. `add buy milk` / `add read book` / `done 1` / `show` / `q` → `1: read book` / `items left: 1`
**Hints:** ① after `cin >> cmd`, `cin.ignore()` then getline the task; ② erase with `v.begin() + (N-1)`.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <vector>
using namespace std;
int main() {
    vector<string> todo;
    string cmd;
    while (cin >> cmd && cmd != "q") {
        cin.ignore();
        if (cmd == "add") {
            string task;
            getline(cin, task);
            todo.push_back(task);
        } else if (cmd == "done") {
            int n;
            cin >> n;
            if (n >= 1 && n <= (int)todo.size()) todo.erase(todo.begin() + (n - 1));
        } else if (cmd == "show") {
            for (size_t i = 0; i < todo.size(); i++)
                cout << (i + 1) << ": " << todo[i] << "\n";
        }
    }
    cout << "items left: " << todo.size() << "\n";
    return 0;
}
```

**Explanation:** push_back, erase-at-index, size — the vector CRUD trio inside a command loop, with the getline-after-`>>` discipline from I-13 doing real work. The bounds check on `done` is the erase-safety habit. *Distinct idea:* dynamic lists without memory management.

---

### C-08 — set-based dedup with sorted report

**Difficulty:** ★★ · **Topics:** STL, set, uniqueness

Read n (0–1000) integers (any range, duplicates expected). Insert them into a `set<int>`; print `unique: K`, then the values ascending on one line, then how many duplicates were dropped.

**Input:** n, then n integers.
**Output:** two lines.
**Sample tests:** `7 4 2 4 3 2 9 4` → `unique: 4` / `2 3 4 9` / `dropped: 3`
**Hints:** ① a set refuses duplicates silently — `insert` returns a pair whose `.second` says whether it landed; ② the set iterates in sorted order by definition.
**Reference solution**

```cpp
#include <iostream>
#include <set>
using namespace std;
int main() {
    int n;
    cin >> n;
    set<int> s;
    int landed = 0;
    for (int i = 0; i < n; i++) {
        int x;
        cin >> x;
        if (s.insert(x).second) landed++;
    }
    cout << "unique: " << s.size() << "\n";
    bool first = true;
    for (int v : s) {
        if (!first) cout << " ";
        cout << v;
        first = false;
    }
    cout << "\ndropped: " << n - landed << "\n";
    return 0;
}
```

**Explanation:** I-08's hand-rolled membership compaction becomes three lines — and `insert`'s returned pair makes "how many were dropped" free. The set's sorted iteration replaces the sort the manual version never even attempted. *Distinct idea:* the container enforces the invariant.

---

### C-09 — vector of records sorted by comparator

**Difficulty:** ★★★ · **Topics:** STL, sort, comparators, records

Read n (1–100) player lines `name score`. Store in a `vector` of a small struct; `sort` with a custom comparator (score descending, name ascending on ties); print the ranked list with positions: `1. name score`.

**Input:** n, then n lines.
**Output:** n ranked lines.
**Sample tests:** n=3 `Danish 70` `Ayesha 90` `Bilal 90` → `1. Ayesha 90` / `2. Bilal 90` / `3. Danish 70`
**Hints:** ① the comparator is a bool function of two records: return a higher score, or equal score and smaller name; ② `sort(v.begin(), v.end(), cmp)`.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;

struct Player { string name; int score; };

bool rankOrder(const Player& a, const Player& b) {
    if (a.score != b.score) return a.score > b.score;
    return a.name < b.name;
}

int main() {
    int n;
    cin >> n;
    vector<Player> v(n);
    for (int i = 0; i < n; i++) cin >> v[i].name >> v[i].score;
    sort(v.begin(), v.end(), rankOrder);
    for (int i = 0; i < n; i++)
        cout << (i + 1) << ". " << v[i].name << " " << v[i].score << "\n";
    return 0;
}
```

**Explanation:** A-31's two-key selection sort becomes a library sort with a named comparator — the same ordering logic, stated once, delegated to code that's already correct. Writing `rankOrder` as a real function (not an inline lambda) keeps it testable and matches the STL module's naming rule. *Distinct idea:* ordering as a named, reusable function.

---

### C-10 — map frequency census (unbounded values)

**Difficulty:** ★★★ · **Topics:** STL, map, counting

Read n (1–1000) integers — *unbounded* range, so direct-index tallying (I-09) is impossible. Count them in a `map<int,int>`; print each distinct value ascending with its count, then the mode (smallest value among the most frequent).

**Input:** n, then n integers (−10⁹…10⁹).
**Output:** `v: c` lines then `mode: M`.
**Sample tests:** `7 5 -3 5 0 5 -3 2` → `-3: 2` / `0: 1` / `2: 1` / `5: 3` / `mode: 5`
**Hints:** ① `freq[x]++` creates the entry on first use — that's the map's magic; ② the map iterates ascending, so the mode scan keeps the *first* maximal count.
**Reference solution**

```cpp
#include <iostream>
#include <map>
using namespace std;
int main() {
    int n;
    cin >> n;
    map<int, int> freq;
    for (int i = 0; i < n; i++) {
        int x;
        cin >> x;
        freq[x]++;
    }
    int mode = 0, best = 0;
    bool first = true;
    for (auto& p : freq) {
        cout << p.first << ": " << p.second << "\n";
        if (first || p.second > best) { best = p.second; mode = p.first; first = false; }
    }
    cout << "mode: " << mode << "\n";
    return 0;
}
```

**Explanation:** the operator-`[]`-creates-entries behavior — a side effect to avoid in *lookups* (STL module's D1) is exactly the tool when the intent *is* insertion-or-increment. Ascending iteration gives sorted output and a stable mode rule for free. *Distinct idea:* count-by-assignment.

---

### C-11 — Algorithm toolkit over a vector

**Difficulty:** ★★ · **Topics:** STL, algorithms, max_element, accumulate

Read n (1–1000) integers into a `vector<long long>`. Using only library algorithms (no hand loops), print: max (`max_element`), min (`min_element`), sum (`accumulate`), count of values > 100 (`count_if`), and the average (two decimals, computed from the sum).

**Input:** n, then n integers (−10⁹…10⁹).
**Output:** five labeled values.
**Sample tests:** `5 250 90 300 101 60` → `max: 300` / `min: 60` / `sum: 801` / `above100: 2` / `avg: 160.20`
**Hints:** ① `*max_element(v.begin(), v.end())`; ② `accumulate` needs `<numeric>` and a 0LL start for long long sums; ③ `count_if` with a plain function predicate.
**Reference solution**

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <numeric>
#include <iomanip>
using namespace std;

bool above100(long long x) { return x > 100; }

int main() {
    int n;
    cin >> n;
    vector<long long> v(n);
    for (int i = 0; i < n; i++) cin >> v[i];
    long long sum = accumulate(v.begin(), v.end(), 0LL);
    cout << "max: " << *max_element(v.begin(), v.end()) << "\n"
         << "min: " << *min_element(v.begin(), v.end()) << "\n"
         << "sum: " << sum << "\n"
         << "above100: " << count_if(v.begin(), v.end(), above100) << "\n"
         << fixed << setprecision(2) << "avg: " << (double)sum / n << "\n";
    return 0;
}
```

**Explanation:** five analyses, zero loops — each algorithm *is* a loop the student wrote by hand in earlier tiers (Ba-02, Ba-34, I-03), now called by name. The `0LL` accumulator argument is the type lesson from I-03 recurring in library clothing. *Distinct idea:* hand-rolled loops become library calls.

---

### C-12 — stack: balanced brackets

**Difficulty:** ★★★ · **Topics:** STL, stack, matching

Read one line of brackets `()[]{}`. Print `BALANCED` if every opener closes in the right order, else `UNBALANCED`. Empty input line is balanced.

**Input:** one line (0–200 chars).
**Output:** one word.
**Sample tests:** `{[()]}` → `BALANCED` · `([)]` → `UNBALANCED` · `((` → `UNBALANCED`
**Hints:** ① push openers; ② on a closer, the stack top must be its partner — pop and verify; ③ balanced at the end also requires an *empty* stack.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <stack>
using namespace std;

char partner(char close) {
    if (close == ')') return '(';
    if (close == ']') return '[';
    return '{';
}

int main() {
    string s;
    getline(cin, s);
    stack<char> st;
    bool ok = true;
    for (size_t i = 0; i < s.size() && ok; i++) {
        char c = s[i];
        if (c == '(' || c == '[' || c == '{') st.push(c);
        else if (c == ')' || c == ']' || c == '}') {
            if (st.empty() || st.top() != partner(c)) ok = false;
            else st.pop();
        }
    }
    cout << (ok && st.empty() ? "BALANCED" : "UNBALANCED") << "\n";
    return 0;
}
```

**Explanation:** the stack's LIFO discipline *is* the nesting rule — most-recently-opened must close first. Three failure modes each get a guard: closer with empty stack, closer with wrong partner, openers left over. The same matcher validates JSON, code editors, and the compiler's own parser. *Distinct idea:* LIFO as nesting semantics.

---

### C-13 — priority_queue task scheduler

**Difficulty:** ★★★ · **Topics:** STL, priority_queue, comparators

Tasks arrive as `p priority name` (priority 1 = highest … 9 = lowest). After all input ends with `run k`, pop and print the k highest-priority tasks in order. Ties: earlier-arrived first.

**Input:** task lines, then `run k`.
**Output:** k lines `name (priority)`; if fewer tasks than k, print all then `empty`.
**Sample tests:** `p 3 laundry` `p 1 exam` `p 2 report` `run 2` → `exam (1)` / `report (2)`
**Hints:** ① the default priority_queue pops the *largest* — number priorities so larger = more urgent, or write a comparator; ② ties need an arrival counter in the payload and a tie-aware comparator.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <queue>
#include <vector>
using namespace std;

struct Task { int priority; int arrival; string name; };

struct WorseTask {
    bool operator()(const Task& a, const Task& b) const {
        if (a.priority != b.priority) return a.priority > b.priority; // smaller number = more urgent
        return a.arrival > b.arrival;                                 // earlier arrival first
    }
};

int main() {
    priority_queue<Task, vector<Task>, WorseTask> pq;
    string cmd;
    int arrived = 0;
    while (cin >> cmd && cmd != "run") {
        int pr;
        string name;
        cin >> pr >> name;
        pq.push(Task{pr, arrived++, name});
    }
    int k;
    cin >> k;
    while (k-- > 0 && !pq.empty()) {
        Task t = pq.top();
        pq.pop();
        cout << t.name << " (" << t.priority << ")\n";
    }
    if (pq.empty() && k >= 0) cout << "empty\n";
    return 0;
}
```

**Explanation:** the custom comparator inverts the default order and breaks ties by arrival — the two-decision comparison shape from C-09, now steering a heap. The `empty` handling covers the k-exceeds-tasks edge the samples deliberately include. *Distinct idea:* priority as a defined ordering.

---

### C-14 — unordered_set fast overlap

**Difficulty:** ★★ · **Topics:** STL, unordered_set, membership

Read two lists: n (1–1000) then n integers, m then m integers. Print how many of the *second* list appear in the first (`overlap: K`), using an unordered_set for O(1) lookups.

**Input:** n, n ints; m, m ints.
**Output:** `overlap: K`.
**Sample tests:** first `4 10 20 30 40`, second `5 30 5 40 99 10` → `overlap: 3`
**Hints:** ① insert list one into `unordered_set<int>`; ② `s.count(x)` answers membership in constant time.
**Reference solution**

```cpp
#include <iostream>
#include <unordered_set>
using namespace std;
int main() {
    int n, m;
    cin >> n;
    unordered_set<int> first;
    for (int i = 0; i < n; i++) { int x; cin >> x; first.insert(x); }
    cin >> m;
    int overlap = 0;
    for (int i = 0; i < m; i++) {
        int x;
        cin >> x;
        if (first.count(x)) overlap++;
    }
    cout << "overlap: " << overlap << "\n";
    return 0;
}
```

**Explanation:** the two-list membership problem — O(n·m) with nested scans — becomes O(n + m) by paying one build pass for constant-time queries. That trade (hash build vs repeated scan) is the exact argument the STL module made for unordered containers; here it's measurable. *Distinct idea:* precompute-then-query.

---

## Part 3 — Exception systems (C-15…C-18)

### C-15 — Throwing config parser

**Difficulty:** ★★★ · **Topics:** exceptions, stoi, validation

Read n lines, each meant to be `key=value` with an integer value (e.g. `port=8080`). For each line, print `key -> value` — or `BAD: reason` where reason is `NOEQ` (no equals), `NOTINT` (value not an integer, caught from `stoi`'s `invalid_argument`), or `EMPTY`. Count the good ones.

**Input:** n (1–20), then n lines.
**Output:** per-line verdicts then `good: K`.
**Sample tests:** `port=8080` / `host` / `retries=x` / `=5` → `port -> 8080` / `BAD: NOEQ` / `BAD: NOTINT` / `BAD: EMPTY` / `good: 1`
**Hints:** ① find `=`, slice both sides; ② wrap `stoi` in try/catch for `invalid_argument`; ③ an empty key or value is its own verdict.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <stdexcept>
using namespace std;

int main() {
    int n;
    cin >> n;
    cin.ignore();
    int good = 0;
    for (int i = 0; i < n; i++) {
        string line;
        getline(cin, line);
        size_t eq = line.find('=');
        if (eq == string::npos) { cout << "BAD: NOEQ\n"; continue; }
        string key = line.substr(0, eq);
        string val = line.substr(eq + 1);
        if (key.empty() || val.empty()) { cout << "BAD: EMPTY\n"; continue; }
        try {
            int v = stoi(val);
            cout << key << " -> " << v << "\n";
            good++;
        } catch (const invalid_argument&) {
            cout << "BAD: NOTINT\n";
        }
    }
    cout << "good: " << good << "\n";
    return 0;
}
```

**Explanation:** layered verdicts — structural checks first (the `if` guards), *conversion* failures via the exception the standard library actually throws. Mixed guard/try styles in one function is realistic; each failure class reports distinctly instead of collapsing into "bad input". *Distinct idea:* catching what the library throws.

---

### C-16 — Bank exception hierarchy with a catch ladder

**Difficulty:** ★★★ · **Topics:** exceptions, custom exceptions, inheritance

Design `class BankError : public runtime_error` (base), with `InsufficientFunds` (carries the shortfall) and `InvalidAmount` derived. `withdraw(acc, amt)` throws `InvalidAmount` for amt ≤ 0 and `InsufficientFunds` when amt > balance. Process commands; catch the ladder in order (most derived first) and print the specific message; print the surviving balance at the end.

**Input:** opening balance, then `W amt` lines ending with `Q`.
**Output:** per-command messages, then `balance: B`.
**Sample tests:** `5000` `W 2000` `W 9999` `W -5` `Q` → `ok` / `SHORTFALL: 4999` / `BAD AMOUNT` / `balance: 3000`
**Hints:** ① catch derived types *before* the base or they'll never be seen; ② carry the shortfall inside the exception object.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <stdexcept>
using namespace std;

class BankError : public runtime_error {
public:
    BankError(const string& msg) : runtime_error(msg) {}
};

class InsufficientFunds : public BankError {
    long long shortfall;
public:
    InsufficientFunds(long long s) : BankError("shortfall"), shortfall(s) {}
    long long getShortfall() const { return shortfall; }
};

class InvalidAmount : public BankError {
public:
    InvalidAmount() : BankError("bad amount") {}
};

long long balance = 0;

void withdraw(long long amt) {
    if (amt <= 0) throw InvalidAmount();
    if (amt > balance) throw InsufficientFunds(amt - balance);
    balance -= amt;
}

int main() {
    cin >> balance;
    string cmd;
    while (cin >> cmd && cmd != "Q") {
        long long amt;
        cin >> amt;
        try {
            withdraw(amt);
            cout << "ok\n";
        } catch (const InsufficientFunds& e) {
            cout << "SHORTFALL: " << e.getShortfall() << "\n";
        } catch (const BankError&) {
            cout << "BAD AMOUNT\n";
        }
    }
    cout << "balance: " << balance << "\n";
    return 0;
}
```

**Explanation:** the exception family is an inheritance hierarchy — which is why catch *order* is semantics, not style: `InsufficientFunds` before `BankError`, or the base handler swallows everything. Data on the exception (the shortfall) replaces error-message parsing: the object *is* the error report. (One global here is deliberate — the alternative, a class instance, is the stated extension.) *Distinct idea:* typed errors with data.

---

### C-17 — Exception-safe file loader (no leaks, clear failure)

**Difficulty:** ★★★ · **Topics:** exceptions, files, safety

Write `vector<string> loadLines(const string& fname)` that throws `runtime_error("cannot open")` if the file fails to open. Main calls it inside try/catch: on success print the line count and the first line (or `EMPTY FILE`), on failure print the error. The loader must leak nothing on any path — use only STL containers (no `new`).

**Input:** a filename (try both an existing file you make and one that doesn't exist).
**Output:** as specified.
**Sample tests:** existing `notes.txt` with 2 lines → `lines: 2` / `first: <line1>`; missing `ghost.txt` → `error: cannot open`
**Hints:** ① `vector` cleans itself up — the no-`new` rule *is* the safety mechanism; ② the throw must happen before any processing.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdexcept>
using namespace std;

vector<string> loadLines(const string& fname) {
    ifstream in(fname);
    if (!in) throw runtime_error("cannot open");
    vector<string> lines;
    string line;
    while (getline(in, line)) lines.push_back(line);
    return lines;
}

int main() {
    string fname;
    cin >> fname;
    try {
        vector<string> lines = loadLines(fname);
        cout << "lines: " << lines.size() << "\n";
        if (lines.empty()) cout << "EMPTY FILE\n";
        else               cout << "first: " << lines[0] << "\n";
    } catch (const runtime_error& e) {
        cout << "error: " << e.what() << "\n";
    }
    return 0;
}
```

**Explanation:** exception safety by *construction* — the vector owns its memory through throws, returns, and scope exits alike, so there is no cleanup path to get wrong. The error message travels in the exception; the caller decides presentation. This is RAII doing the work the manual `new`/`delete` version would have to do by hand. *Distinct idea:* safety from ownership by container.

---

### C-18 — Retry reader with a throwing validator

**Difficulty:** ★★ · **Topics:** exceptions, loops, robust input

Write `int readInRange(int lo, int hi)` that reads integers, throwing `invalid_argument` for out-of-range values — and a main loop that catches, prints `retry: `, and tries again (max 3 attempts before giving up with `FAILED`). Read a mark in 0–100 this way.

**Input:** a sequence of integers; the first in-range one (or failure) ends input.
**Output:** `retry: ` per failed attempt then the value, or `FAILED`.
**Sample tests:** `150 90` → `retry: 90` · `150 200 300` → `retry: retry: retry: FAILED`
**Hints:** ① the throw happens *inside* the reader; the catch loop *drives* the retries — separation of check from policy; ② count attempts in the loop, not the function.
**Reference solution**

```cpp
#include <iostream>
#include <stdexcept>
using namespace std;

int readInRange(int lo, int hi) {
    int v;
    cin >> v;
    if (v < lo || v > hi) throw invalid_argument("range");
    return v;
}

int main() {
    bool ok = false;
    int value = 0;
    for (int attempt = 0; attempt < 3 && !ok; attempt++) {
        try {
            value = readInRange(0, 100);
            ok = true;
        } catch (const invalid_argument&) {
            cout << "retry: ";
        }
    }
    if (ok) cout << value << "\n";
    else    cout << "FAILED\n";
    return 0;
}
```

**Explanation:** the reader *detects*, the loop *decides* — detection and retry policy in different layers, each testable alone. Compare Ba-34's do-while version: same behavior, but here the failure is an *object* crossing the boundary, which is what lets the policy layer exist. *Distinct idea:* detection and policy separated.

---

## Part 4 — Integrated problems (C-19…C-24)

### C-19 — Student records end-to-end (structs + files + stats)

`roster.txt` holds `name marks` lines. Load into a struct array (max 100), then print: the class average (two decimals), the topper line(s) with ties, and the count below 50. Handle a missing file with a message and exit code 1.

**Input:** the file `roster.txt`.
**Output:** `avg: X` / topper lines / `below50: K`.
**Sample tests:** file `Ayesha 88` `Bilal 42` `Sara 88` `Danish 30` → `avg: 62.00` / `Ayesha 88` / `Sara 88` / `below50: 2`
**Hints:** ① load-then-analyze: three passes over stored records; ② each stat is one small loop.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
#include <iomanip>
using namespace std;

struct Student { string name; int marks; };

int main() {
    ifstream in("roster.txt");
    if (!in) { cout << "cannot open roster.txt\n"; return 1; }
    Student s[100];
    int n = 0;
    while (n < 100 && (in >> s[n].name >> s[n].marks)) n++;
    if (n == 0) { cout << "no records\n"; return 1; }

    long long total = 0;
    int below50 = 0;
    for (int i = 0; i < n; i++) {
        total += s[i].marks;
        if (s[i].marks < 50) below50++;
    }
    int best = s[0].marks;
    for (int i = 1; i < n; i++) if (s[i].marks > best) best = s[i].marks;

    cout << fixed << setprecision(2) << "avg: " << (double)total / n << "\n";
    for (int i = 0; i < n; i++)
        if (s[i].marks == best) cout << s[i].name << " " << s[i].marks << "\n";
    cout << "below50: " << below50 << "\n";
    return 0;
}
```

**Explanation:** the full pipeline — file to records to three independent statistics — where each analysis pass is one loop over stored data. Load-once, analyze-many is the shape every data program takes; the missing-file guard and empty-roster guard bookend it honestly. *Distinct idea:* load once, analyze many.

---

### C-20 — Inventory low-stock report (records + sorting + files)

`stock.txt` holds `name qty` lines (qty ≥ 0). Load products, then print: the total item count, all products with qty below 10 sorted by qty ascending (name ascending on ties) as `name qty LOW`, and the single most-stocked product.

**Input:** the file `stock.txt`.
**Output:** `total: T` / low-stock lines / `most: name qty`.
**Sample tests:** file `Pen 3` `Pad 990` `Ink 3` `Clip 50` → `total: 4` / `Ink 3 LOW` / `Pen 3 LOW` / `most: Pad 990`
**Hints:** ① collect low-stock items into a second array, then sort *that*; ② the most-stocked scan runs on the full array.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

struct Product { string name; int qty; };

int main() {
    ifstream in("stock.txt");
    if (!in) { cout << "cannot open stock.txt\n"; return 1; }
    Product all[100], low[100];
    int n = 0, ln = 0;
    while (n < 100 && (in >> all[n].name >> all[n].qty)) {
        if (all[n].qty < 10) low[ln++] = all[n];
        n++;
    }
    cout << "total: " << n << "\n";
    for (int i = 0; i < ln - 1; i++) {
        int best = i;
        for (int j = i + 1; j < ln; j++)
            if (low[j].qty < low[best].qty ||
               (low[j].qty == low[best].qty && low[j].name < low[best].name))
                best = j;
        if (best != i) { Product t = low[i]; low[i] = low[best]; low[best] = t; }
    }
    for (int i = 0; i < ln; i++) cout << low[i].name << " " << low[i].qty << " LOW\n";
    if (n > 0) {
        int most = 0;
        for (int i = 1; i < n; i++) if (all[i].qty > all[most].qty) most = i;
        cout << "most: " << all[most].name << " " << all[most].qty << "\n";
    }
    return 0;
}
```

**Explanation:** filter-then-sort-then-report — the low-stock subset is collected first (so the sort costs less and the report is clean), while the "most" query walks the full set. Data flowing through stages, each stage owning one job, is the integration habit the capstone formalizes. *Distinct idea:* pipeline over records.

---

### C-21 — Text file analyzer (strings + files)

Analyze `article.txt`: print `lines: L` / `words: W` / `chars: C` / `longest: WORD` (the first longest word if ties) / `vowelWords: K` (words starting with a vowel, case-insensitive).

**Input:** the file `article.txt`.
**Output:** five labeled values.
**Sample tests:** file `C++ is powerful\nand elegant` → `lines: 2` / `words: 5` / `chars: 24` / `longest: powerful` / `vowelWords: 2` (and, elegant)
**Hints:** ① per line: token scan (I-15) updating all tallies; ② track longest with a `>` test so the *first* longest wins ties.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
#include <cctype>
using namespace std;

bool startsVowel(const string& w) {
    if (w.empty()) return false;
    char c = tolower(w[0]);
    return c=='a'||c=='e'||c=='i'||c=='o'||c=='u';
}

int main() {
    ifstream in("article.txt");
    if (!in) { cout << "cannot open article.txt\n"; return 1; }
    long long lines = 0, words = 0, chars = 0, vowelWords = 0;
    string line, longest = "";
    while (getline(in, line)) {
        lines++;
        chars += line.size() + 1;
        string cur = "";
        for (size_t i = 0; i <= line.size(); i++) {
            if (i == line.size() || line[i] == ' ') {
                if (!cur.empty()) {
                    words++;
                    if (startsVowel(cur)) vowelWords++;
                    if (cur.size() > longest.size()) longest = cur;
                    cur = "";
                }
            } else cur += line[i];
        }
    }
    cout << "lines: " << lines << "\nwords: " << words << "\nchars: " << chars << "\n"
         << "longest: " << (longest.empty() ? "NONE" : longest) << "\n"
         << "vowelWords: " << vowelWords << "\n";
    return 0;
}
```

**Explanation:** one scanner, five reports — every token feeds all the tallies (word count, vowel check, longest tracking) as it passes. The `>` comparison is the tie-to-first rule; the empty-file path prints `NONE` instead of a lie. Per-line scanning with `getline` keeps the counter definitions explicit. *Distinct idea:* multi-report single pass.

---

### C-22 — Validated transaction log (files + append + validation)

Maintain `ledger.txt` where each line is an integer amount. Commands: `a amt` (append amt if amt ≠ 0, else print `REJECTED`), `bal` (print the sum of all logged amounts — read the file fresh), `q`. On `q`, print `entries: K`.

**Input:** commands ending with `q`.
**Output:** as specified.
**Sample tests:** `a 100` `a -30` `a 0` `bal` `q` → `REJECTED` (for the 0? No — 0 is rejected: `a 0` prints `REJECTED`) / `bal: 70` / `entries: 2`
**Hints:** ① append mode for `a`; a fresh read pass for `bal` — state lives in the file, not memory; ② validate before appending.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
using namespace std;
int main() {
    string cmd;
    int entries = 0;
    while (cin >> cmd && cmd != "q") {
        if (cmd == "a") {
            long long amt;
            cin >> amt;
            if (amt == 0) { cout << "REJECTED\n"; continue; }
            ofstream out("ledger.txt", ios::app);
            out << amt << "\n";
            entries++;
        } else if (cmd == "bal") {
            ifstream in("ledger.txt");
            long long bal = 0, x;
            while (in >> x) bal += x;
            cout << "bal: " << bal << "\n";
        }
    }
    cout << "entries: " << entries << "\n";
    return 0;
}
```

**Explanation:** the file is the system of record — appends add, `bal` recomputes from disk rather than trusting memory — the persistence discipline that survives crashes (and program restarts). The zero-amount guard is validation at the boundary; entries counted only for accepted appends matches the sample. *Distinct idea:* disk as the source of truth.

---

### C-23 — File-driven quiz engine (records + logic + files)

`quiz.txt` holds lines `question|answer` (question text has no `|`; answer is one word). Ask each question, read the user's answer, count correct. At the end print `score: C/W`, then list missed questions as `MISSED: question`.

**Input:** the file, then user answers at runtime.
**Output:** per-question nothing; final score block.
**Sample tests:** quiz.txt `Capital of Pakistan|Islamabad` `2+2|4`; user answers `islamabad` `5` → `score: 1/2` / `MISSED: 2+2`
**Hints:** ① store missed questions for the end-of-run review; ② answers compare case-insensitively — lowercase both sides before testing.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
#include <cctype>
using namespace std;

string lower(string s) {
    for (size_t i = 0; i < s.size(); i++) s[i] = tolower(s[i]);
    return s;
}

int main() {
    ifstream in("quiz.txt");
    if (!in) { cout << "cannot open quiz.txt\n"; return 1; }
    string line;
    int correct = 0, total = 0;
    string missedQ[50];
    int missedN = 0;
    while (getline(in, line) && total < 50) {
        size_t bar = line.find('|');
        if (bar == string::npos) continue;
        string q = line.substr(0, bar);
        string a = line.substr(bar + 1);
        total++;
        cout << "Q" << total << ": " << q << "\n> ";
        string ans;
        getline(cin, ans);
        if (lower(ans) == lower(a)) correct++;
        else missedQ[missedN++] = q;
    }
    cout << "score: " << correct << "/" << total << "\n";
    for (int i = 0; i < missedN; i++) cout << "MISSED: " << missedQ[i] << "\n";
    return 0;
}
```

**Explanation:** data-driven quiz — the question bank *is* the program's content, so adding questions means editing a text file, not code. Case-blind comparison is the fairness rule; the missed-question review collects state across the run for the end report. Same engine, new domain — the pattern Project 5 scales. *Distinct idea:* content as data.

---

### C-24 — Section gradebook (matrices + functions + stats)

Read s (1–5) sections. For each: n_i students with one mark each. Print per-section average, then the *global* average across all sections, then which section leads (highest average; ties → lowest section number).

**Input:** s, then for each section: n (1–30) followed by n marks (0–100).
**Output:** `sec i: avg` lines (i from 1), `overall: X`, `lead: i`.
**Sample tests:** s=2, sec1: `3 80 90 70` (avg 80), sec2: `2 60 100` (avg 80) → `sec 1: 80.00` / `sec 2: 80.00` / `overall: 80.00` / `lead: 1`
**Hints:** ① accumulate global sums *while* reading sections — no need to store every mark; ② the lead scan compares averages with a strict `>` so ties keep the earlier section.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;
int main() {
    int s;
    cin >> s;
    double secAvg[5];
    long long grandSum = 0;
    int grandN = 0;
    for (int sec = 1; sec <= s; sec++) {
        int n;
        cin >> n;
        long long sum = 0;
        for (int i = 0; i < n; i++) {
            int m;
            cin >> m;
            sum += m;
        }
        secAvg[sec - 1] = (double)sum / n;
        grandSum += sum;
        grandN += n;
    }
    for (int sec = 1; sec <= s; sec++)
        cout << "sec " << sec << ": " << fixed << setprecision(2) << secAvg[sec - 1] << "\n";
    cout << "overall: " << (double)grandSum / grandN << "\n";
    int lead = 0;
    for (int i = 1; i < s; i++) if (secAvg[i] > secAvg[lead]) lead = i;
    cout << "lead: " << lead + 1 << "\n";
    return 0;
}
```

**Explanation:** hierarchical aggregation — per-section sums while streaming, global sums accumulated alongside, then the lead scan over the small averages array. Streaming what can be streamed, storing only what must be compared later, is the memory-conscious reading habit the analytics labs reward. *Distinct idea:* aggregate at each level.

---

## Part 5 — Cross-topic challenges (C-25…C-40)

### C-25 — Recursive palindrome (strings + recursion + functions)

**Difficulty:** ★★ · **Topics:** strings, recursion, functions

Write `bool isPalRec(const string& s, size_t lo, size_t hi)` deciding palindrome by comparing the outer pair and recursing inward. Read a single word (lowercase letters); print `YES`/`NO`.

**Input:** one word, 1–100 chars.
**Output:** one word.
**Sample tests:** `radar` → `YES` · `hello` → `NO`
**Hints:** ① base: lo ≥ hi means checked everything; ② mismatch → false immediately.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

bool isPalRec(const string& s, size_t lo, size_t hi) {
    if (lo >= hi) return true;              // met in the middle: all pairs matched
    if (s[lo] != s[hi]) return false;
    return isPalRec(s, lo + 1, hi - 1);
}

int main() {
    string w;
    cin >> w;
    cout << (isPalRec(w, 0, w.size() - 1) ? "YES" : "NO") << "\n";
    return 0;
}
```

**Explanation:** the same inward scan as I-16's two-pointer check, expressed recursively — the "lo/hi window" is now parameters that shrink. Even-length and odd-length words land in the same base case (`lo >= hi`), which is why no special case exists. *Distinct idea:* range parameters as recursive state.

---

### C-26 — Array function library (functions + arrays)

**Difficulty:** ★★ · **Topics:** functions, arrays

Build and demonstrate four array functions: `void reverseArr(int a[], int n)` (in-place, I-04), `void rotateRight(int a[], int n, int k)` (in-place via three reversals — reverse all, reverse first k, reverse rest), `bool isSorted(int a[], int n)` (A-32), and `void copyArr`. Read n, n values, and k; print the array after rotation only — but the test case must prove all four work (describe your checks in comments).

**Input:** n (1–50), n integers, k (0–n).
**Output:** the rotated line.
**Sample tests:** `5 1 2 3 4 5 2` → `4 5 1 2 3`
**Hints:** ① the three-reversal trick rotates in place with no second array; ② reverseArr powers all three reversal steps.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

void reverseArr(int a[], int lo, int hi) {        // inclusive bounds
    while (lo < hi) { int t = a[lo]; a[lo] = a[hi]; a[hi] = t; lo++; hi--; }
}

void rotateRight(int a[], int n, int k) {
    k %= n;
    reverseArr(a, 0, n - 1);   // 5 4 3 2 1
    reverseArr(a, 0, k - 1);   // 4 5 3 2 1
    reverseArr(a, k, n - 1);   // 4 5 1 2 3
}

bool isSorted(int a[], int n) {
    for (int i = 1; i < n; i++) if (a[i] < a[i-1]) return false;
    return true;
}

int main() {
    int n, a[50], k;
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    cin >> k;
    rotateRight(a, n, k);
    for (int i = 0; i < n; i++) cout << a[i] << " \n"[i == n - 1];
    // Checks: reverseArr alone on the input must give 5 4 3 2 1;
    // isSorted on the rotated result must be false, on 1 2 3 true.
    return 0;
}
```

**Explanation:** the three-reversal rotation — a classic composed *entirely from* a simpler function — is the composition argument in algorithm form: one well-tested helper, three call sites, zero extra memory. The comment-checked demonstrations formalize "functions as testable units". *Distinct idea:* algorithms composed from helpers.

---

### C-27 — Manual dynamic growth (pointers + arrays)

**Difficulty:** ★★★ · **Topics:** pointers, dynamic memory, amortized growth

Read integers until `0` into a **dynamically growing** array you manage yourself: start capacity 4; when full, allocate double, copy, free the old. Print the final count, the final capacity, and the sum. Use only `new[]`/`delete[]` — no vector.

**Input:** integers ending with 0 (at most 1000).
**Output:** `count: N cap: C sum: S`.
**Sample tests:** `1 2 3 4 5 0` → `count: 5 cap: 8 sum: 15`
**Hints:** ① grow exactly when count == capacity; ② the copy loop is the whole cost of growth; ③ never lose the old pointer before copying.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int cap = 4, count = 0;
    long long sum = 0;
    int* data = new int[cap];
    long long x;
    while (cin >> x && x != 0) {
        if (count == cap) {
            int* bigger = new int[cap * 2];
            for (int i = 0; i < cap; i++) bigger[i] = data[i];
            delete[] data;          // free only after copying
            data = bigger;
            cap *= 2;
        }
        data[count++] = (int)x;
        sum += x;
    }
    cout << "count: " << count << " cap: " << cap << " sum: " << sum << "\n";
    delete[] data;
    return 0;
}
```

**Explanation:** vector's growth strategy, hand-cranked — double on demand, copy, release — which is why the amortized story from the STL module is believable: 1000 appends cost ~2000 copies, not 500,000. The copy-before-free ordering is the bug class; the final capacity (8 for 5 items) exposes the growth schedule. *Distinct idea:* growth as an explicit policy.

---

### C-28 — Write your own strlen and strcmp (pointers + strings)

**Difficulty:** ★★ · **Topics:** pointers, strings, library reimplementation

Implement `size_t myStrlen(const char* s)` and `int myStrcmp(const char* a, const char* b)` using *only* pointer arithmetic (no `[]`, no library calls). Read two words; print each length and the comparison verdict `NEG`/`ZERO`/`POS` (as strcmp does: a−b sign at the first differing char).

**Input:** two words (1–50 chars, lowercase).
**Output:** two lengths then the verdict.
**Sample tests:** `apple banana` → `5` / `6` / `NEG` (a < b at 'a' vs 'b'? both 'a'… differ at index 1: p < a → NEG)
**Hints:** ① walk until `*p == '\0'`; ② strcmp returns the *difference* of the first differing characters.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

size_t myStrlen(const char* s) {
    const char* p = s;
    while (*p != '\0') p++;
    return p - s;                      // pointer difference = element count
}

int myStrcmp(const char* a, const char* b) {
    while (*a != '\0' && *a == *b) { a++; b++; }
    return (unsigned char)*a - (unsigned char)*b;
}

int main() {
    string x, y;
    cin >> x >> y;
    cout << myStrlen(x.c_str()) << "\n" << myStrlen(y.c_str()) << "\n";
    int cmp = myStrcmp(x.c_str(), y.c_str());
    cout << (cmp < 0 ? "NEG" : cmp == 0 ? "ZERO" : "POS") << "\n";
    return 0;
}
```

**Explanation:** reimplementing the C-string library with pure pointer walks — `p - s` as length, advance-while-equal as compare — shows what the functions always did: address arithmetic with a null-terminator contract. The cast to `unsigned char` is why strcmp is safe on all inputs; knowing *why* is the challenge. *Distinct idea:* the library as pointer arithmetic you can write.

---

### C-29 — Alphabetize a line's words (strings + sorting)

**Difficulty:** ★★ · **Topics:** strings, sorting

Read one line of lowercase words (single spaces). Print them alphabetically, one per line.

**Input:** one line, 2–20 words.
**Output:** sorted words.
**Sample tests:** `pear apple fig apple` → `apple` / `apple` / `fig` / `pear`
**Hints:** ① tokenize into a string array (I-15); ② sort with string `<` — lexicographic order is built in.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <algorithm>
using namespace std;
int main() {
    string line, words[20];
    getline(cin, line);
    int n = 0;
    string cur = "";
    for (size_t i = 0; i <= line.size(); i++) {
        if (i == line.size() || line[i] == ' ') {
            if (!cur.empty()) words[n++] = cur;
            cur = "";
        } else cur += line[i];
    }
    sort(words, words + n);
    for (int i = 0; i < n; i++) cout << words[i] << "\n";
    return 0;
}
```

**Explanation:** tokenize then `sort` — where C-09 needed a custom comparator for *records*, plain strings order themselves by `<`. The duplicated `apple` in the sample pins down that this is a *sort*, not a dedup (C-08's job). *Distinct idea:* the type carries its own ordering.

---

### C-30 — Password-rule checker over a file (strings + files)

`candidates.txt` holds one password per line. A valid password: 8–16 chars, at least one digit, at least one uppercase letter. For each line print `name of line N: OK` or the *first failed rule* — `SHORT`, `LONG`, `NO-DIGIT`, `NO-UPPER`. End with `valid: K`.

**Input:** the file `candidates.txt`.
**Output:** verdict lines then `valid: K`.
**Sample tests:** file `hello` / `Password1` / `nodigits8A` — wait, `nodigits8A` has 10 chars, a digit 8, uppercase A → OK. Use `short1A` (7 chars) → SHORT. Sample: `hello` → NO-DIGIT? First check order: length first → `SHORT`. File: `short1A` / `Password1` / `alllowercase1` → `1: SHORT` / `2: OK` / `3: NO-UPPER` / `valid: 1`
**Hints:** ① rule order is spec: length, then digit, then upper — report the *first* failure; ② one pass per line with flags.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
#include <cctype>
using namespace std;
int main() {
    ifstream in("candidates.txt");
    if (!in) { cout << "cannot open candidates.txt\n"; return 1; }
    string pw;
    int n = 0, valid = 0;
    while (getline(in, pw)) {
        n++;
        if (pw.size() < 8)      { cout << n << ": SHORT\n";    continue; }
        if (pw.size() > 16)     { cout << n << ": LONG\n";     continue; }
        bool digit = false, upper = false;
        for (size_t i = 0; i < pw.size(); i++) {
            if (isdigit(pw[i])) digit = true;
            if (isupper(pw[i])) upper = true;
        }
        if (!digit)      { cout << n << ": NO-DIGIT\n"; continue; }
        if (!upper)      { cout << n << ": NO-UPPER\n"; continue; }
        cout << n << ": OK\n";
        valid++;
    }
    cout << "valid: " << valid << "\n";
    return 0;
}
```

**Explanation:** rules applied in *declared priority* — the early `continue` chain guarantees the first-failure report and keeps each rule readable alone. The two flags after the length gate collect character-class evidence in one pass; rule order versus pass order is exactly the kind of spec detail the samples enforce. *Distinct idea:* prioritized rule chains.

---

### C-31 — Switchable product sort (structures + sorting)

Read n (1–30) product lines `name price`, then a sort key letter: `n` (name ascending), `p` (price descending). Sort the struct array accordingly (selection or insertion, hand-written) and print the result.

**Input:** n, n lines, then the key letter.
**Output:** n lines.
**Sample tests:** n=3 `Pad 990` `Apple 20` `Ink 95`, key `p` → `Pad 990` / `Ink 95` / `Apple 20`
**Hints:** ① one comparison function chosen by the key letter; ② the struct swap keeps fields paired (I-32's rule).
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <iomanip>
using namespace std;

struct Product { string name; double price; };

bool nameFirst(const Product& a, const Product& b) { return a.name < b.name; }
bool priceFirst(const Product& a, const Product& b) { return a.price > b.price; }

int main() {
    int n;
    char key;
    Product p[30];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> p[i].name >> p[i].price;
    cin >> key;
    bool (*cmp)(const Product&, const Product&) =
        (key == 'n') ? nameFirst : priceFirst;
    for (int i = 0; i < n - 1; i++) {
        int best = i;
        for (int j = i + 1; j < n; j++)
            if (cmp(p[j], p[best])) best = j;
        if (best != i) { Product t = p[i]; p[i] = p[best]; p[best] = t; }
    }
    cout << fixed << setprecision(2);
    for (int i = 0; i < n; i++) cout << p[i].name << " " << p[i].price << "\n";
    return 0;
}
```

**Explanation:** the sort *algorithm* stays fixed; only the comparison is chosen at runtime — a function selected by a letter, stored in a function-pointer variable. (No classes needed to see the idea: strategy selection predates OOP.) The two comparators are named and testable independently. *Distinct idea:* algorithm fixed, comparison injected.

---

### C-32 — Struct array CSV round-trip (structures + files)

Read n (1–20) employee lines `name salary` from stdin; write them to `emp.csv` as `name,salary`; then load the file back and print each line — proving the round trip preserved everything. Report `roundtrip: OK` if every reloaded record equals its source.

**Input:** n, then n lines (salaries 1–10⁶).
**Output:** the reloaded lines then `roundtrip: OK`.
**Sample tests:** n=2 `Ayesha 80000` `Bilal 65000` → `Ayesha 80000` / `Bilal 65000` / `roundtrip: OK`
**Hints:** ① write with commas, read with I-24's find/split; ② compare field by field after the reload.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

struct Emp { string name; long long salary; };

int main() {
    int n;
    cin >> n;
    Emp src[20];
    for (int i = 0; i < n; i++) cin >> src[i].name >> src[i].salary;

    ofstream out("emp.csv");
    for (int i = 0; i < n; i++) out << src[i].name << "," << src[i].salary << "\n";
    out.close();

    ifstream in("emp.csv");
    Emp dst[20];
    int m = 0;
    string line;
    while (m < n && getline(in, line)) {
        size_t comma = line.find(',');
        dst[m].name   = line.substr(0, comma);
        dst[m].salary = stoll(line.substr(comma + 1));
        m++;
    }
    bool ok = (m == n);
    for (int i = 0; i < m; i++) {
        cout << dst[i].name << " " << dst[i].salary << "\n";
        if (dst[i].name != src[i].name || dst[i].salary != src[i].salary) ok = false;
    }
    cout << "roundtrip: " << (ok ? "OK" : "MISMATCH") << "\n";
    return 0;
}
```

**Explanation:** serialize-load-verify — the round-trip test is the strongest simple check that a file format actually captures the data, and it catches encoding mistakes (delimiters, missing lines) that "it seems to work" never will. Field-by-field comparison, not line comparison, localizes any mismatch. *Distinct idea:* persistence proven by round trip.

---

### C-33 — grep-lite (files + searching + strings)

Read a key word, then scan `haystack.txt`. Print every line containing the key as a **whole word**, prefixed with its 1-based line number. End with `hits: K`.

**Input:** the key (one word), then the file is read.
**Output:** hit lines then `hits: K`.
**Sample tests:** key `PASS`, file `Ali PASS 88` / `Bilal PASSING 40` → `1: Ali PASS 88` / `hits: 1`
**Hints:** ① token-scan each line (A-16's exact-token rule); ② collect the verdict before printing.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
using namespace std;
int main() {
    string key;
    cin >> key;
    ifstream in("haystack.txt");
    if (!in) { cout << "cannot open haystack.txt\n"; return 1; }
    string line;
    int ln = 0, hits = 0;
    while (getline(in, line)) {
        ln++;
        bool hit = false;
        string cur = "";
        for (size_t i = 0; i <= line.size() && !hit; i++) {
            if (i == line.size() || line[i] == ' ') {
                if (cur == key) hit = true;
                cur = "";
            } else cur += line[i];
        }
        if (hit) { cout << ln << ": " << line << "\n"; hits++; }
    }
    cout << "hits: " << hits << "\n";
    return 0;
}
```

**Explanation:** A-16's token-exact filter gains line numbers and a key read from the user — the same scanner, now a small *tool*. The scan stops at the first hit per line (`!hit` in the loop condition), because reporting is per-line, not per-occurrence: the grain of the question defines the loop's exit. *Distinct idea:* tools from composed filters.

---

### C-34 — Top-k from a big file without full sorting (files + arrays)

`big.txt` holds up to 100000 integers. Print the k largest (k ≤ 10), descending, **without sorting everything**: keep a tiny sorted list of the k best seen so far and insert each newcomer into it (dropping the smallest when over k).

**Input:** k (1–10), then the file `big.txt`.
**Output:** k lines.
**Sample tests:** k=3, file `5 99 3 77 99 1` → `99` / `99` / `77`
**Hints:** ① the best-list stays sorted ascending — the head is the weakest; ② insert with shifting (insertion sort on ≤ 11 elements).
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
using namespace std;
int main() {
    int k;
    cin >> k;
    ifstream in("big.txt");
    if (!in) { cout << "cannot open big.txt\n"; return 1; }
    long long best[11];
    int bn = 0, x;
    while (in >> x) {
        // insert x into ascending best[0..bn) if it beats the weakest or list isn't full
        if (bn < k || x > best[0]) {
            if (bn == k) {
                // drop the smallest: shift everything left
                for (int i = 0; i + 1 < bn; i++) best[i] = best[i + 1];
                bn--;
            }
            int j = bn - 1;
            while (j >= 0 && best[j] > x) { best[j + 1] = best[j]; j--; }
            best[j + 1] = x;
            bn++;
        }
    }
    for (int i = bn - 1; i >= 0; i--) cout << best[i] << "\n";
    return 0;
}
```

**Explanation:** streaming top-k — a constant-size ordered window replaces a full sort (100000·log n comparisons become ≤ 100000·10 shifts). The duplicates case (`99` twice) tests the insert path; the `>` at the head check is what keeps junk out of the window entirely. This is the selection side of the sorting module's cost discussion. *Distinct idea:* a window instead of a sort.

---

### C-35 — Recursive vowel counter (recursion + strings)

**Difficulty:** ★★ · **Topics:** recursion, strings

Write `int countVowRec(const string& s, size_t i)` counting vowels from index i onward, recursively — no loops anywhere. Read one lowercase word; print the count.

**Input:** one word, 1–100 chars.
**Output:** one integer.
**Sample tests:** `education` → `5` · `xyz` → `0`
**Hints:** ① base: i == s.size() → 0; ② step: (isVowel ? 1 : 0) + countVowRec(s, i + 1).
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

bool isVowel(char c) {
    return c=='a'||c=='e'||c=='i'||c=='o'||c=='u';
}

int countVowRec(const string& s, size_t i) {
    if (i == s.size()) return 0;
    return (isVowel(s[i]) ? 1 : 0) + countVowRec(s, i + 1);
}

int main() {
    string w;
    cin >> w;
    cout << countVowRec(w, 0) << "\n";
    return 0;
}
```

**Explanation:** B-35's traversal loop as pure recursion — the loop counter became the index parameter, the accumulator became the sum assembling on the unwind. Clean enough to *see* the loop/recursion equivalence: same shape, two notations. *Distinct idea:* the loop-recursion duality on text.

---

### C-36 — Find the minimum in a rotated sorted array (searching)

**Difficulty:** ★★★ · **Topics:** searching, binary search variant, boundaries

A sorted array was rotated (e.g. `4 5 6 7 1 2 3`). Read n (2–100) then the rotated array; find the minimum in O(log n) with a modified binary search. Print `min: M at: I`.

**Input:** n, then n distinct integers forming a rotated sorted array.
**Output:** one line.
**Sample tests:** `7 4 5 6 7 1 2 3` → `min: 1 at: 4` · `4 2 5 7 9` → `min: 2 at: 0` — careful: `2 5 7 9` rotated by 0 isn't rotated; use `3 7 9 2 5` → `min: 2 at: 3`
**Hints:** ① compare mid against the *rightmost* element: a[mid] > a[hi] means the minimum is right of mid; else it's at mid or left; ② converge lo and hi onto the minimum.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    int lo = 0, hi = n - 1;
    while (lo < hi) {
        int mid = lo + (hi - lo) / 2;
        if (a[mid] > a[hi]) lo = mid + 1;   // the drop (minimum) is to the right
        else                 hi = mid;      // minimum at mid or to the left
    }
    cout << "min: " << a[lo] << " at: " << lo << "\n";
    return 0;
}
```

**Explanation:** binary search's invariant bent to a new question — instead of comparing against the *key*, compare mid against the right end to sense which side the rotation drop lives on. The loop ends when lo == hi, which must be the minimum. Same skeleton as A-25/A-27, new invariant: that transferability is the skill. *Distinct idea:* the invariant defines the search.

---

### C-37 — Two-sum in a sorted array (searching + two pointers)

**Difficulty:** ★★ · **Topics:** searching, two pointers

Read n (2–1000), n **sorted** integers, and a target t. Print the 0-based pair `(i, j)` with i < j and a[i] + a[j] == t using two pointers from both ends — O(n). If none, print `NONE`.

**Input:** n, sorted ints, t.
**Output:** `i j` or `NONE`.
**Sample tests:** `5 1 3 5 7 9 12` → `1 3` (3+9) · same, t=20 → `NONE`
**Hints:** ① sum too small → move the left pointer right; too big → move the right left; ② stop when they meet.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[1000], t;
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    cin >> t;
    int lo = 0, hi = n - 1;
    bool found = false;
    while (lo < hi) {
        long long s = a[lo] + a[hi];
        if (s == t)      { cout << lo << " " << hi << "\n"; found = true; break; }
        else if (s < t)  lo++;
        else             hi--;
    }
    if (!found) cout << "NONE\n";
    return 0;
}
```

**Explanation:** sortedness buys the two-pointer walk: each comparison *eliminates* one end of the array, so n steps suffice instead of n². The movement rule (small → advance low, big → retreat high) is the entire algorithm; proving no pair is skipped is the reasoning the explanation demands. *Distinct idea:* eliminated ends as progress.

---

### C-38 — Sort names by length, then alphabet (sorting + strings)

**Difficulty:** ★★ · **Topics:** sorting, strings

Read n (1–30) names, then sort by length ascending; equal lengths sort alphabetically. Print the result.

**Input:** n, then n names (one word each).
**Output:** n lines.
**Sample tests:** n=4 `Sara` `Ali` `Bilal` `Umar` → `Ali` / `Umar` / `Sara` / `Bilal`
**Hints:** ① the comparator: shorter first; equal length → string `<`; ② `sort` with the two-key comparator (C-09's shape).
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

bool order(const string& a, const string& b) {
    if (a.size() != b.size()) return a.size() < b.size();
    return a < b;
}

int main() {
    int n;
    cin >> n;
    string names[30];
    for (int i = 0; i < n; i++) cin >> names[i];
    sort(names, names + n, order);
    for (int i = 0; i < n; i++) cout << names[i] << "\n";
    return 0;
}
```

**Explanation:** a two-key comparator where the *primary* key is a derived property (`size()`), not a stored one — the same tie-break ladder as C-09 with length in the driver's seat. `Ali`/`Umar` (both 3) prove the alphabetical tie rule fires. *Distinct idea:* derived keys in comparators.

---

### C-39 — Matrix multiply as functions (arrays + functions)

**Difficulty:** ★★★ · **Topics:** arrays, matrices, functions

Write `void readMatrix(int g[][10], int r, int c)`, `void multiply(int a[][10], int b[][10], int out[][10], int r, int k, int c)` (with the inner-product triple loop), and `void printMatrix`. Read r, k for A; k, c for B (same inner dimension); print A×B.

**Input:** r, k, then A (r×k); then c, then B (k×c).
**Output:** the r×c product, rows on lines.
**Sample tests:** A = 2×2 `1 2 3 4`, B = 2×2 `5 6 7 8` → `19 22` / `43 50`
**Hints:** ① out[i][j] = Σ a[i][t]·b[t][j]; ② the inner dimension k appears in both signatures — that's the legality check.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

void readMatrix(int g[][10], int r, int c) {
    for (int i = 0; i < r; i++)
        for (int j = 0; j < c; j++)
            cin >> g[i][j];
}

void multiply(int a[][10], int b[][10], int out[][10], int r, int k, int c) {
    for (int i = 0; i < r; i++)
        for (int j = 0; j < c; j++) {
            int sum = 0;
            for (int t = 0; t < k; t++) sum += a[i][t] * b[t][j];
            out[i][j] = sum;
        }
}

void printMatrix(int g[][10], int r, int c) {
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++)
            cout << g[i][j] << " \n"[j == c - 1];
    }
}

int main() {
    int r, k, c, A[10][10], B[10][10], C[10][10];
    cin >> r >> k;
    readMatrix(A, r, k);
    cin >> c;
    readMatrix(B, k, c);
    multiply(A, B, C, r, k, c);
    printMatrix(C, r, c);
    return 0;
}
```

**Explanation:** matrix multiplication decomposed into read/compute/print functions — main reads dimensions and delegates, and the `[][10]` parameter form (columns fixed at declaration) is the two-dimensional array-passing rule in practice. The k in both reads *is* the dimensional compatibility check made structural. *Distinct idea:* dimension flow through signatures.

---

### C-40 — The everything harness (integrated)

**Difficulty:** ★★★ · **Topics:** integration, arrays, functions, files, validation

Build a number-collection harness over a dynamic int array (start cap 8, double-on-full — C-27's policy):
`add x` (reject |x| > 10⁹ with `REJECTED`), `stats` (count, sum, average two decimals, min, max — or `EMPTY`), `save` (writes all values to `nums.txt`, one per line), `load` (replaces the collection with the file's values, count printed), `q`.

**Input:** commands ending with `q`.
**Output:** as specified per command.
**Sample tests:** `add 10` `add -4` `add 0` `stats` `save` `load` `stats` `q` → stats1: `count: 3 sum: 6 avg: 2.00 min: -4 max: 10` · after save+load, stats2 identical — the round-trip proves persistence.
**Hints:** ① the growth policy is C-27 verbatim — write it once as `void ensureCap(int*& data, int& cap, int need);` ② stats is one pass with four accumulators; ③ load rebuilds through the same `add` path so validation can't be bypassed.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <iomanip>
using namespace std;

void ensureCap(int*& data, int& cap, int need) {
    if (need <= cap) return;
    int* bigger = new int[cap * 2];
    for (int i = 0; i < cap; i++) bigger[i] = data[i];
    delete[] data;
    data = bigger;
    cap *= 2;
}

int main() {
    int cap = 8, count = 0;
    int* data = new int[cap];
    string cmd;
    while (cin >> cmd && cmd != "q") {
        if (cmd == "add") {
            long long x;
            cin >> x;
            if (x < -1000000000LL || x > 1000000000LL) { cout << "REJECTED\n"; continue; }
            ensureCap(data, cap, count + 1);
            data[count++] = (int)x;
        } else if (cmd == "stats") {
            if (count == 0) { cout << "EMPTY\n"; continue; }
            long long sum = data[0];
            int mn = data[0], mx = data[0];
            for (int i = 1; i < count; i++) {
                sum += data[i];
                if (data[i] < mn) mn = data[i];
                if (data[i] > mx) mx = data[i];
            }
            cout << "count: " << count << " sum: " << sum
                 << " avg: " << fixed << setprecision(2) << (double)sum / count
                 << " min: " << mn << " max: " << mx << "\n";
        } else if (cmd == "save") {
            ofstream out("nums.txt");
            for (int i = 0; i < count; i++) out << data[i] << "\n";
            cout << "saved: " << count << "\n";
        } else if (cmd == "load") {
            ifstream in("nums.txt");
            if (!in) { cout << "no file\n"; continue; }
            count = 0;
            long long x;
            while (in >> x) {
                if (x < -1000000000LL || x > 1000000000LL) continue;
                ensureCap(data, cap, count + 1);
                data[count++] = (int)x;
            }
            cout << "loaded: " << count << "\n";
        }
    }
    cout << "final count: " << count << "\n";
    delete[] data;
    return 0;
}
```

**Explanation:** the final synthesis — growth policy (C-27), single-pass stats (Ba-02), validated input (Ba-34's layer), file persistence (A-11), and round-trip verification (C-32) — in one program where every subsystem is a function with a narrow job. `load` routing through the same validation and growth paths as `add` is the quiet architectural point: *one* ingestion path means one place for the rules. This harness is the capstone's engine room, everything except classes. *Distinct idea:* one ingestion path for all data.

---

**Tier check:** 40 problems · C-01–C-40 · complete [the checklist](index.md) — the bank is finished when every box is ticked and every sample plus one self-invented test has passed.
