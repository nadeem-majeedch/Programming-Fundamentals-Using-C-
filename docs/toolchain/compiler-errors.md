---
title: "Compiler Error Catalogue"
description: "The most common beginner C++ errors, what they actually mean, and how to fix them."
---

# Compiler Error Catalogue

> Read the FIRST error; the rest are usually echoes · [FAQ](../faq.md) · [Course home](../index.md)

Errors below are shown in g++ style (Clang and MSVC word things differently,
but the causes are identical). This catalogue grows as the course grows.

---

## Missing semicolon

```text
error: expected ';' before '}' token
```

**Cause:** a statement on the line *above* the reported line is missing its
`;`.
**Fix:** look at the previous line; add the semicolon.

## Unknown name / not declared

```text
error: 'cout' was not declared in this scope
error: 'sting' was not declared in this scope
```

**Cause:** a misspelled name, or a missing `#include`, or you forgot
`std::`.
**Fix:** check spelling character by character; `#include <iostream>` for
`cout`/`cin`; write `std::cout` (or meet `using` properly when the course
introduces it).

## Undeclared (first use in this function) — old compiler style

```text
error: 'x' undeclared (first use in this function)
```

**Cause:** using a variable before declaring it, or a typo in the name
(`count` vs `cout` is the classic).
**Fix:** declare the variable, or fix the spelling.

## Unterminated comment / string

```text
error: unterminated comment
warning: missing terminating " character
```

**Cause:** `/*` without its closing `*/`, or a closing quote `"` forgotten
mid-line.
**Fix:** close the comment or the string.

## Invalid preprocessing directive

```text
error: invalid preprocessing directive #inclde
```

**Cause:** a typo in a `#` line.
**Fix:** `#include <iostream>` — note the spelling and the angle brackets.

## Uninitialized variable (warning)

```text
warning: 'total' is used uninitialized [-Wuninitialized]
```

**Cause:** reading a variable before giving it a value.
**Fix:** initialize it: `int total = 0;` — the course treats warnings as
errors to fix, never to ignore.

## Unused variable (warning)

```text
warning: unused variable 'x' [-Wunused-variable]
```

**Cause:** declared but never used — often a sign of an unfinished thought.
**Fix:** use it or remove it.

## Multiply-defined / redefinition

```text
error: redefinition of 'int main()'
```

**Cause:** two `main` functions in one file (often from merging example
files).
**Fix:** one `main` per program; move the second into a comment or a
function.

## Divide-style logic errors (no error at all!)

**Symptom:** the program runs but prints wrong numbers.
**Cause:** this is a **logic error** — the compiler understood you perfectly;
you asked for the wrong thing. Classic first case: integer division
(`5 / 2` is `2`, not `2.5` — Unit 02 explains).
**Fix:** trace with small values; use the debugger; simplify.

---

## Reading error messages: the general recipe

1. Read the **first** error and its line number.
2. The real cause is often **on that line or just above**.
3. Fix one thing, **recompile** — don't fix five things before rebuilding.
4. If the message mentions a name, check spelling, `#include`, and `std::`.
5. Still stuck after a few minutes? Find it in the
   [FAQ](../faq.md#troubleshooting-quick-answers) or report it via
   [CONTRIBUTING](https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-/blob/main/CONTRIBUTING.md).

---

*[← Toolchain](../getting-started/index.md) · [How to Study](../how-to-study.md#what-to-do-when-something-breaks)*
