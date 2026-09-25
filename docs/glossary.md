---
title: "Glossary"
description: "Every term used in Programming Fundamentals Using C++, defined simply."
---

# Glossary

> Every term, defined simply, with the unit where it first appears ·
> [Course home](index.md)

This glossary grows with the course. Terms are listed alphabetically; the
**U** column tells you where each term is first explained. Terms below cover
the [Getting Started](getting-started/index.md) pack and
[Unit 01](units/unit-01-introduction-to-programming-and-cpp/index.md).

## A–B

| Term | Meaning | First used |
| --- | --- | --- |
| **Array** | A fixed-size row of same-typed boxes under one name, addressed by index `0..n-1`. | Unit 09 |
| **Bounds** | The rule that valid indices run `0` to `size − 1`; anything else is undefined behaviour. | Unit 09 |
| **Argument** | A value you pass to a function when calling it. | Unit 07 |
| **Pass-by-value** | Arguments are copied into parameters — the function cannot change the caller's variable. | Functions module |
| **Parameter** | The named slot in a function definition; receives a copy of the argument (unless declared `T&`). | Unit 07 |
| **Frequency counting (tally array)** | An array whose *indices are categories* and whose boxes are counters — `tally[value] += 1` bumps the right one. | Arrays module |
| **Index** | An array box's position number — the offset from the first box. | Unit 09 |
| **Logical size vs capacity** | Capacity is how many boxes an array has; the logical size is how many are in use. Every data pass runs `0..n-1`. | Arrays module |
| **Prototype** | A function's signature declared without a body — the program's table of contents. | Unit 07 |
| **Reference parameter (`T&`)** | A parameter bound to the caller's own variable — the sanctioned write-back channel. | Functions module |
| **Return value** | The result a function hands back to its caller via `return`; `void` functions return nothing. | Unit 07 |
| **Scope** | The region of code where a variable's name is usable. | Unit 07 |
| **Void function** | A function that performs an action and returns no value. | Unit 07 |
| **Block** | Code between a pair of braces `{ }`, treated as one unit. | Unit 01 |
| **Bug** | A mistake in a program that makes it behave incorrectly. | Unit 01 |
| **Build** | Compiling + linking — the whole journey from source to runnable program. | Week 0 |
| **Compile error** (see compile error entry) | — | Week 0 |
| **Compile-time** | While the compiler is translating; errors here stop the build. | Week 0 |
| **Logic error** | Legal, runnable code that computes the wrong thing — caught only by checking results. | Week 0 |
| **Linker** | The step that stitches object files and libraries into one executable; its classic complaint is `undefined reference`. | Week 0 |
| **Object file** | The compiler's half-finished output (`.o` / `.obj`): machine code for your functions, not yet linked. | Week 0 |
| **PATH** | The list of folders the shell searches for commands; why `g++` may be installed but "not found". | Week 0 |


## C

| Term | Meaning | First used |
| --- | --- | --- |
| **Cast (explicit)** | A programmer-requested type change: `static_cast<double>(x)`. | C++ Foundations module |
| **CLI** | Command-line interface — typing commands instead of clicking. | Getting Started |
| **Comment** | Text in the source code for humans; the compiler ignores it (`//` to end of line). | Unit 01 |
| **Compile** | Translate human-readable C++ into machine-readable instructions. | Unit 01 |
| **Compiler** | The program that does the translating (e.g. g++, Clang, MSVC). | Unit 01 |
| **Compile error** | A message the compiler prints when it cannot understand your code; it usually names a line number. | Unit 01 |
| **Compound assignment** | Update-in-place shorthand: `x += 5` means `x = x + 5`. | C++ Foundations module |
| **Console** | The text window where programs read input and print output. | Unit 01 |
| **Counter** | A variable that counts events — incremented by a fixed amount (usually 1) each pass. | Iteration module |
| **Constant** | A named value that cannot change after initialization (`const`). | C++ Foundations module |
| **cpp** | The usual file extension for C++ source files. | Unit 01 |
| **Extraction operator (`>>`)** | Reads a value from `cin`, skipping leading whitespace and stopping before what it cannot convert. | C++ Input/Output module |
| **Flush** | Forcing buffered output to be delivered now — `std::endl` does it, `'\n'` does not. | C++ Input/Output module |
| **getline** | `std::getline(cin, s)` — reads a whole line including spaces into `s` and consumes the newline. | C++ Input/Output module |
| **Input buffer** | The waiting area where typed characters queue before your program reads them. | C++ Input/Output module |
| **Insertion operator (`<<`)** | Sends a value to an output stream such as `cout`. | C++ Input/Output module |
| **Manipulator** | A stream modifier such as `setw`, `setprecision`, `fixed`, `endl`, `boolalpha`. | C++ Input/Output module |
| **Mixing trap** | The classic bug: `cin >>` leaves a newline that a following `getline` reads as an empty line. | C++ Input/Output module |
| **Nested loop** | A loop inside another loop's body; the inner completes fully per outer pass; work = outer × inner. | Iteration module |
| **Off-by-one error** | A loop boundary mistake — one pass too many or too few (`<` vs `<=`). | Iteration module |
| **Validation loop** | Keep asking until the input is usable: `clear()`, `ignore()`, read, check. | C++ Input/Output module |
| **Whitespace** | Space, tab, and newline characters — skipped by `>>`, significant to `getline`. | C++ Input/Output module |

## D–E

| Term | Meaning | First used |
| --- | --- | --- |
| **Directory** | A folder on disk. | Getting Started |
| **Edit–compile–run cycle** | The loop of writing code, compiling it, and running it — the daily rhythm of programming. | Unit 01 |
| **Executable** | The runnable file the compiler produces (`.exe` on Windows, usually no extension on Linux/macOS). | Unit 01 |
| **`endl`** | Ends the output line and forces flushing; `\n` usually preferred for plain newlines. | Unit 01 |

## G–I

| Term | Meaning | First used |
| --- | --- | --- |
| **IDE** | Integrated development environment — an editor with build tools built in. | Getting Started |
| **Include** | Pull a library's declarations into your file: `#include <iostream>`. | Unit 01 |
| **Infinite loop** | A loop whose condition can never become false — usually a missing, wrong-direction, or defeated update. | Iteration module |
| **Iteration** | One complete pass of a loop body; also the general act of repeating. | Iteration module |
| **Loop** | A construct that repeats statements while a condition holds: `while`, `do-while`, `for`. | Iteration module |

## M–O

| Term | Meaning | First used |
| --- | --- | --- |
| **Identifier** | The name given to a variable, function, or constant — rules + conventions apply. | C++ Foundations module |
| **Implicit conversion** | A type change the compiler performs automatically (e.g. int → double in mixed arithmetic). | C++ Foundations module |
| **Increment/decrement** | `++`/`--`: add or subtract one; prefix applies first, postfix after. | C++ Foundations module |
| **Initialization** | Creating a variable AND giving it its first value. | C++ Foundations module |
| **Integer division** | `/` between ints: the fraction is truncated (7/2 is 3). | C++ Foundations module |
| **Literal** | A value written directly in code — `25`, `3.14`, `'A'`, `true`, `"hi"` — type from its form. | C++ Foundations module |
| **Logical operators** | `&&` (AND), `||` (OR), `!` (NOT) — combine booleans; both && and \|\| short-circuit. | C++ Foundations module |
| **`main`** | The function where every C++ program starts running. | Unit 01 |
| **`std`** | The namespace holding the C++ standard library names. | Unit 01 |
| **Source code** | The C++ text you write; the compiler's input. | Unit 01 |
| **Statement** | A single instruction, normally ending with `;`. | Unit 01 |
| **`std::cout`** | The standard output stream — `cout` prints text to the console. | Unit 01 |
| **Stream** | A sequence of data flowing to or from your program (cout = out, cin = in). | Unit 01 |

## P–S

| Term | Meaning | First used |
| --- | --- | --- |
| **Guard chain** | A sequence of `if … return` checks that ends the program on each failure — reaching the next line means every earlier rule passed. Order *is* precedence. | Decisions module, Lab 4 |
| **AND-gate** | A compound condition (one `if` with `&&`) that opens only when every part holds — e.g. relay eligibility requires age in range *and* consent. | Decisions module, Lab 5 |
| **Short-circuit evaluation** | `&&` stops at the first false; `||` stops at the first true — the right side may never run. Makes guard conditions like `count != 0 && total / count > 10` safe. | Decisions module |
| **Prime number** | A whole number above 1 whose only divisors are 1 and itself; testable by counting divisors. | Iteration module |
| **Prime read** | The input read placed *before* a sentinel loop, so the condition has data to test. | Iteration module |
| **Base case** | The smallest input a recursive function answers directly, without calling itself — the exit door every call chain must reach. | Algorithms module |
| **Call stack** | The stack of active function frames; recursion stacks many copies of the same frame, and exhausting the stack is a stack overflow. | Algorithms module |
| **Binary search** | Search on sorted data that eliminates half the range per comparison — O(log n) — and returns wrong answers silently on unsorted input. | Algorithms module |
| **O(n²) / O(n log n) / O(log n)** | Growth-shape shorthand: work proportional to n², to n·log₂n, or to log₂n. Counting comparisons reveals which shape an algorithm has. | Algorithms module |
| **Logic error** | A program that compiles and runs but answers wrong — detected by nobody but tests, traces, or suspicion. | Debugging module |
| **Breakpoint** | A marker telling the debugger to pause before a line runs, so state can be inspected and execution stepped. | Debugging module |
| **Boundary test** | A test case on each side of a threshold or edge (0, 1, n−1, n) — where correctness bugs cluster. | Debugging module |
| **Regression testing** | Re-running every accumulated test after each change, so a fixed bug cannot silently return. | Debugging module |
| **DRY** | Don't Repeat Yourself — every piece of knowledge gets one authoritative home; duplication manufactures divergent bugs. | Debugging module |
| **Encapsulation** | Private attributes behind a guarded public interface — invariants enforced by the compiler, not by discipline. | OOP module |
| **Constructor** | The method that runs automatically at object creation, making the object valid before anyone can touch it. | OOP module |
| **Destructor** | The method that runs automatically at object death, releasing whatever the object acquired. | OOP module |
| **`this`** | The hidden pointer every method receives — the address of the object on whose behalf the method runs. | OOP module |
| **const member function** | A method promising not to modify the object; callable through const references. | OOP module |
| **Composition (has-a)** | One object containing another as an attribute — invariants compose; lifetimes nest. | OOP module |
| **Base / derived class** | The inherited-from class and the inheriting class — the derived receives attributes and methods, then adds or refines. | Inheritance module |
| **`protected`** | Members visible to derived classes (and only them) — a thinner wall whose invariants every subclass must now maintain. | Inheritance module |
| **`virtual` / overriding** | A virtual method's call follows the object's real type at runtime — the machinery of polymorphism; `override` makes the compiler verify it. | Inheritance module |
| **Abstract class** | A class with a pure virtual function — it cannot be instantiated, only inherited from; it is a contract. | Inheritance module |
| **Slicing** | Copying a derived object by value into a base — the derived part and its vptr are amputated; store polymorphic families behind pointers. | Inheritance module |
| **Operator overloading** | Giving a user-defined type the built-in operator notation — as a member (left operand is the object) or non-member (symmetry; forced for streams). | Generics module |
| **Function template** | A pattern with a type parameter, stamped per type by the compiler — compile-time polymorphism. | Generics module |
| **Class template** | A class pattern (`Box<T>`) whose uses name the type argument; every stamp is a distinct class. | Generics module |
| **Generic contract** | The set of operations a template's body demands of `T` — named in a comment, enforced by the compiler at the stamp site. | Generics module |
| **npos** | The special value `std::string::find` returns when the target is absent — check it before any slice. | Strings module |
| **State machine** | Code that carries a tiny amount of status between steps (e.g. `inWord`) so context changes behaviour — the word-counting pattern. | Strings module |
| **Address** | The number of a byte-sized memory box; `&x` asks for the address where `x` lives. | Pointers module |
| **Pointer** | A variable whose value is the address of another variable; its type is a promise about what's there. | Pointers module |
| **Dereference** | `*p` — follow the pointer's arrow and act on the target: read it, or (on the left of `=`) write it. | Pointers module |
| **nullptr** | The constant meaning "points at nothing, on purpose" — checkable before any dereference. | Pointers module |
| **Reference** | A second name for an existing variable — born attached, never re-attached, never null. | Pointers module |
| **Ownership** | Exactly one region of code is responsible for deleting each heap box — leaks, double-deletes, and dangling pointers are all ownership failures. | Pointers module |
| **Memory leak** | Heap memory that was allocated, never released, and is no longer reachable — orphaned by a lost or moved arrow. | Pointers module |
| **Dangling pointer** | A pointer whose target has already been freed — prevent with `delete p; p = nullptr;` on one line. | Pointers module |
| **Dynamic array** | A runtime-sized heap block: `new int[n]` … `delete[]` — the pairs must match in form, exactly once. | Pointers module |

| Term | Meaning | First used |
| --- | --- | --- |
| **Accumulator** | A variable that collects a running result (sum, count, champion) across loop iterations. | Problem-Solving module |
| **Algorithm** | A finite, unambiguous, step-by-step procedure that solves a problem. | Problem-Solving module |
| **Assumption** | Something taken for granted about a problem — stated so it can be checked. | Problem-Solving module |
| **Constraint** | A limit a solution must respect (time, format, range). | Problem-Solving module |
| **Decomposition** | Splitting a problem into pieces small enough to solve immediately. | Problem-Solving module |
| **Edge case** | An input at the edge of the ranges — smallest, largest, exactly at a boundary. | Problem-Solving module |
| **Flowchart** | A drawing of an algorithm: rectangles (actions), diamonds (decisions), arrows. | Problem-Solving module |
| **IPO** | Input → Processing → Output: the shape of nearly every program. | Problem-Solving module |
| **Operator precedence** | The fixed order deciding which operator acts first in a mixed expression. | C++ Foundations module |
| **Overflow** | Exceeding a type's range — for `int`, silently wrapping to a wrong value. | C++ Foundations module |
| **Path** | The address of a file or folder, e.g. `C:\code\hello.cpp` or `/home/you/hello.cpp`. | Getting Started |
| **Preprocessor** | The stage before compilation that handles `#include` and `#define` lines. | Week 0 |
| **Pseudocode** | Structured-English algorithm — precise but language-free. | Problem-Solving module |
| **Relational operators** | The six comparisons producing booleans: `== != < <= > >=`. | C++ Foundations module |
| **Requirement** | What a solution must do, per the problem statement. | Problem-Solving module |
| **Runtime error** | An error that appears while the program is running (as opposed to a compile error). | Week 0 · Unit 01 |
| **Sentinel** | A special input value that signals the end of data (e.g. 0 to finish). | Problem-Solving module |
| **Sentinel (choice rule)** | A sentinel must be a value that can never occur as real data; otherwise the loop stops on legitimate input. | Iteration module |
| **Syntax** | The grammar rules of C++. | Unit 01 |
| **Syntax error** | A compile error caused by breaking the grammar (missing `;`, unmatched brace…). | Unit 01 |

## T–Z

| Term | Meaning | First used |
| --- | --- | --- |
| **Terminal** | The window where you type shell commands to compile and run programs. | Getting Started |
| **struct** | A programmer-defined type bundling named members into one value — a blueprint until a variable is declared. | Records module |
| **Member** | A named field inside a struct, accessed with the dot operator (`s.score`). | Records module |
| **Nested structure** | A record whose member is itself a record — dots descend (`b.writer.name`). | Records module |
| **enum / enum class** | A type naming a closed set of values; the class form scopes its names and forbids silent int conversions. | Records module |
| **Magic number** | A raw constant whose meaning lives only in the author's head — enums are the cure. | Records module |
| **Character array** | A C-style box-of-chars ending with the `\0` terminator — the legacy way to hold text; `==` compares addresses, not text. | Strings module |
| **std::string** | The modern C++ text type — grows, compares, searches, and slices itself; the course default. | Strings module |
| **Concatenation** | Joining text with `+` / `+=` — at least one operand must be a `std::string`. | Strings module |
| **Lexicographic order** | Dictionary comparison by character codes — not numeric order, and uppercase before lowercase. | Strings module |
| **Substring** | A piece of a string, cut out with `s.substr(pos, len)` — second argument is a *length*, and it clips silently. | Strings module |
| **Test case** | A planned check: given input → expected output. | Problem-Solving module |
| **Trace table** | A hand-execution of an algorithm written down: one column per variable, one row per step. | Problem-Solving module |
| **Stream** | A sequence of data flowing one way with a `<<`/`>>`/getline interface — `cin`, `cout`, and file streams are the same idea with different destinations. | Files module |
| **ifstream / ofstream** | A stream opened on a file for reading / writing; the writing open truncates unless `std::ios::app` is passed. | Files module |
| **CSV** | Comma-separated values — one record per line, fields delimited by a separator the data never contains. | Files module |
| **EOF** | End of file — *detected* by a failed read (the read goes in the loop condition), never predicted with `eof()`. | Files module |
| **Format contract** | The exact written agreement on a file's bytes, kept beside both the save and load code — changed only in the same edit. | Files module |
| **Truncation** | Dropping the fraction when converting to int (9.7 → 9) — not rounding. | C++ Foundations module |
| **Variable** | A named box in memory holding one value of one declared type. | C++ Foundations module |
| **Warning** | The compiler saying "this is suspicious" — it compiles, but check it. The course compiles with warnings on and treats them as errors to fix. | Unit 01 |
| **Container** | A standard-library object whose job is to hold other objects and answer questions about them — `vector` holds in arrival order, `map` keeps keys sorted, `unordered_map` hashes. | STL module |
| **Iterator** | A generalization of a pointer — the common currency between containers and algorithms; `v.begin()` points at the first element, `v.end()` one *past* the last. | STL module |
| **Range** | A pair of iterators `[begin, end)` — everything from first to one-past-last; the empty range is `begin == end`, and the half-open shape makes it natural. | STL module |
| **Lambda** | An unnamed function written on the spot — a capture list, a parameter list, a body: the brackets decide what outside names the body may use. | STL module |
| **Comparator** | A strict-weak-ordering rule (usually a lambda) answering "is `a` strictly before `b`?" — every STL ordering question is asked this way. | STL module |
| **Amortized cost** | Averages the occasional expensive operation over many cheap ones — `vector::push_back` is O(1) *amortized* even though a growth step copies everything. | STL module |

---

*Misspelled or unclear? [Report it](https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-/blob/main/CONTRIBUTING.md) — the glossary should
never be the hardest part of the course.*
