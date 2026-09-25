---
title: "Project 5 — The Quiz Application"
description: "A menu-driven quiz engine with a question bank, session scoring, review, and replay — driven flows, counters, stored questions, and ladder grading."
---

# Project 5 — The Quiz Application

> [← Projects home](index.md) · [← Project 4](project-04-expense-tracker.md) · Tier: Basic · **Units first: 05–08** — loops, functions, references, decomposition

## Overview

A self-test engine for this course's students: a built-in bank of multiple-choice questions on units 01–06, served in quiz sessions. The player picks a session length, answers, gets a per-question verdict and a final grade, can review wrong answers, and replay until satisfied. Statistics (best score, sessions played) persist for the run.

## Learning objectives

- design a data-driven flow: the quiz is a *list of questions*, not a ladder of prompts
- manage per-question and per-session state through functions
- implement review and statistics over recorded answers
- keep presentation (what prints) separate from logic (what's correct)

## Prerequisites

| Unit | What you need |
| --- | --- |
| 05–06 | loops, counters |
| 07–08 | functions, references, records-lite thinking (parallel vectors) |

## Requirements

1. A bank of **at least 8 MCQs** on Units 01–06, each with 4 options, a correct index, and a one-line explanation.
2. Session: the player chooses 3, 5, or all questions; the bank serves them in order.
3. Per question: print, read 1–4 (invalid → re-prompt, not scored), verdict + explanation; wrong answers are recorded.
4. Final: score, percentage, grade message (≥ 80 Excellent, ≥ 60 Good, ≥ 40 Keep practising, else See the tutor), then the review of wrong answers.
5. Post-session menu: replay, view bank statistics (sessions played, best %), quit.

## Functional requirements

| ID | Statement | Verified by |
| --- | --- | --- |
| F1 | a 3-question session scores and grades correctly | T1 |
| F2 | an invalid answer (0, 5, `abc`) re-prompts without scoring | T2 |
| F3 | the review lists exactly the wrong answers with their explanations | T3 |
| F4 | bank statistics survive across sessions in one run | T4 |
| F5 | every bank question prints with its four options | T5 |

## Suggested data structures

- Parallel vectors for the bank: `vector<string> questionTexts`, `vector<array<string,4>>`… — at this tier, four separate `vector<string>`s (option a–d) or a `vector<string>` per option slot; **the clean answer is a struct, and the project may note that Unit 14 will replace this scaffolding**.
- Session state: `vector<int> askedIndexes`, `vector<char> givenAnswers` — the review's raw material.

## Milestones

- **M1 — one hard-coded question.** Print, read, verdict. *Exit: correct and wrong answers both handled.*
- **M2 — the bank.** All 8 questions in parallel vectors; a session over the full bank. *Exit: T5 passes.*
- **M3 — scoring and grading.** Counters, percentage, ladder. *Exit: T1 passes.*
- **M4 — review.** Record answers; replay the wrong ones with explanations. *Exit: T3 passes.*
- **M5 — statistics + session menu.** Sessions played, best %. *Exit: T4 passes; the whole flow loops.*

## Tasks

1. Write the bank vectors with your 8 questions (draw them from Units 01–06 honestly).
2. Write `askQuestion(index, given&)` — print, validate, verdict, return correctness.
3. Write `runSession(bank..., length, results&)` — the loop, counters, the review.
4. Write `printStats(sessions, bestPercent)`.
5. Write the session menu; run the test plan.

## Test plan

| # | Sequence | Expected |
| --- | --- | --- |
| T1 | 3-question session, all correct | 3/3 (100%), Excellent, empty review |
| T2 | answer `0` then `5` then the right option | two re-prompts, then scored once |
| T3 | answer two wrong | review lists exactly those two, with explanations |
| T4 | session 100%, session 0% → stats | sessions 2, best 100% |
| T5 | full-bank session | all 8 questions in bank order |

## Edge cases

- A player answering before reading (0 seconds) — no timers, but the invalid-then-valid flow must stay clean.
- The review on a perfect session — prints nothing but a congratulation line, not an empty block.
- Session length 5 from an 8-question bank — exactly the first five (documented: no shuffling at this tier).

## Extension ideas

1. Shuffle the question order (seeded, so tests stay deterministic).
2. Load questions from a file — the door to [Project 9](project-09-student-files.md).
3. Category tags per question; the player picks a topic.

## Grading / self-assessment

[Shared rubric](index.md#the-shared-rubric-each-project-page-adds-its-specifics) plus:

- [ ] Adding a 9th question touches only the bank vectors — zero logic changes (+1)
- [ ] Invalid answers are re-prompts, never scores (+1)
- [ ] The review's explanations come from the bank's data, not from duplicated strings (+1)

## Hints

1. The bank *is* the program: if the questions live in vectors, the engine is one loop; if they live in code, it's eight `if`s. Choose vectors.
2. Record `givenAnswers` as chars — the review pairs them with `askedIndexes` to find the wrong ones.
3. The percentage is `correct * 100 / asked` — integer arithmetic is exact when asked divides evenly; use `double` when it doesn't.

## Complete reference solution

```cpp
// quiz.cpp — Programming Fundamentals Using C++
// Project 5 · The Quiz Application
// Build: g++ -std=c++17 -Wall -Wextra quiz.cpp -o quiz

#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
using namespace std;

// The bank: 8 MCQs on Units 01-06. Adding a question = adding to these vectors.
// Parallel-vector scaffolding — Unit 14's struct will replace it cleanly.

void loadBank(vector<string>& q, vector<string>& o1, vector<string>& o2,
              vector<string>& o3, vector<string>& o4, vector<int>& answer,
              vector<string>& why) {
    q.push_back("What does a compiler do?");
    o1.push_back("Runs the program line by line");
    o2.push_back("Translates source code to machine code");
    o3.push_back("Formats the source code");
    o4.push_back("Stores variables");
    answer.push_back(2);
    why.push_back("A compiler translates the whole source to machine code before running.");

    q.push_back("Which type holds 3.14 exactly-ish?");
    o1.push_back("int"); o2.push_back("char"); o3.push_back("double"); o4.push_back("bool");
    answer.push_back(3);
    why.push_back("double is the floating-point type for fractional values.");

    q.push_back("What does cin >> x leave in the buffer?");
    o1.push_back("Nothing"); o2.push_back("The newline"); o3.push_back("The value"); o4.push_back("An error");
    answer.push_back(2);
    why.push_back(">> leaves the newline, which is why getline needs cin.ignore after it.");

    q.push_back("Which loop runs at least once?");
    o1.push_back("while"); o2.push_back("for"); o3.push_back("do-while"); o4.push_back("none");
    answer.push_back(3);
    why.push_back("do-while tests the condition after the body.");

    q.push_back("What prints: cout << 7 / 2;");
    o1.push_back("3.5"); o2.push_back("3"); o3.push_back("4"); o4.push_back("error");
    answer.push_back(2);
    why.push_back("Integer division truncates: 7/2 is 3.");

    q.push_back("Which operator is the equality test?");
    o1.push_back("="); o2.push_back("=="); o3.push_back("==="); o4.push_back("!=");
    answer.push_back(2);
    why.push_back("== compares; = assigns.");

    q.push_back("A sentinel is...");
    o1.push_back("A loop counter");
    o2.push_back("A special value ending input");
    o3.push_back("A kind of if");
    o4.push_back("The loop body");
    answer.push_back(2);
    why.push_back("A sentinel is the agreed value that means 'no more data'.");

    q.push_back("How many times does for(int i=0;i<3;++i) run?");
    o1.push_back("2"); o2.push_back("3"); o3.push_back("4"); o4.push_back("forever");
    answer.push_back(2);
    why.push_back("i = 0, 1, 2 — three iterations.");
}

bool askQuestion(const vector<string>& q, const vector<string>& o1, const vector<string>& o2,
                 const vector<string>& o3, const vector<string>& o4, const vector<int>& answer,
                 const vector<string>& why, size_t index, char& given) {
    cout << "\n" << q[index] << "\n";
    cout << "  1. " << o1[index] << "\n"
         << "  2. " << o2[index] << "\n"
         << "  3. " << o3[index] << "\n"
         << "  4. " << o4[index] << "\n";

    int choice;
    cout << "Your answer (1-4): ";
    cin >> choice;
    while (choice < 1 || choice > 4) {          // invalid: re-prompt, never score
        cout << "Answer with 1-4: ";
        cin >> choice;
    }
    given = static_cast<char>('0' + choice);

    bool correct = (choice == answer[index]);
    cout << (correct ? "Correct! " : "Wrong. ") << why[index] << "\n";
    return correct;
}

void runSession(const vector<string>& q, const vector<string>& o1, const vector<string>& o2,
                const vector<string>& o3, const vector<string>& o4, const vector<int>& answer,
                const vector<string>& why, size_t length,
                vector<size_t>& askedIndexes, vector<char>& givenAnswers) {
    int correct = 0;
    askedIndexes.clear();
    givenAnswers.clear();

    for (size_t i = 0; i < length; ++i) {
        char given;
        if (askQuestion(q, o1, o2, o3, o4, answer, why, i, given)) ++correct;
        askedIndexes.push_back(i);
        givenAnswers.push_back(given);
    }

    int percent = static_cast<int>(correct * 100 / length);
    cout << "\nScore: " << correct << "/" << length << " (" << percent << "%)\n";
    if      (percent >= 80) cout << "Excellent\n";
    else if (percent >= 60) cout << "Good\n";
    else if (percent >= 40) cout << "Keep practising\n";
    else                    cout << "See the tutor\n";

    if (correct == length) {
        cout << "Perfect session — nothing to review\n";
    } else {
        cout << "\nReview of wrong answers:\n";
        for (size_t i = 0; i < askedIndexes.size(); ++i) {
            size_t qi = askedIndexes[i];
            if (givenAnswers[i] - '0' != answer[qi])
                cout << "  " << q[qi] << "\n    you said " << givenAnswers[i]
                     << " — " << why[qi] << "\n";
        }
    }
}

int main() {
    vector<string> q, o1, o2, o3, o4, why;
    vector<int> answer;
    loadBank(q, o1, o2, o3, o4, answer, why);

    int sessions = 0, bestPercent = -1;

    int choice;
    do {
        cout << "\n=== QUIZ ===\n1 Quick (3) · 2 Standard (5) · 3 Full bank ("
             << q.size() << ") · 4 Stats · 0 Quit: ";
        cin >> choice;

        if (choice >= 1 && choice <= 3) {
            size_t length = (choice == 1) ? 3 : (choice == 2) ? 5 : q.size();
            vector<size_t> asked;
            vector<char> given;
            runSession(q, o1, o2, o3, o4, answer, why, length, asked, given);

            ++sessions;
            int correct = 0;
            for (size_t i = 0; i < asked.size(); ++i)
                if (given[i] - '0' == answer[asked[i]]) ++correct;
            int percent = static_cast<int>(correct * 100 / asked.size());
            if (percent > bestPercent) bestPercent = percent;
        } else if (choice == 4) {
            cout << "Sessions played: " << sessions << "\n";
            if (bestPercent >= 0) cout << "Best score: " << bestPercent << "%\n";
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    cout << "Goodbye — " << sessions << " session(s) this run\n";
    return 0;
}
```

## Explanation of important design decisions

- **The bank is data, not code.** All eight questions live in vectors; `askQuestion` never mentions a specific question. Adding the ninth question is six `push_back`s and zero logic edits — the extension rubric tests exactly this, and it is the same data-driven principle that later powers the files-based quiz.
- **Validation lives at the read, verdict lives at the compare.** The 1–4 re-prompt loop guarantees `given` is always a legal answer, so the correctness comparison and the review never face invalid states — validate-at-the-boundary, applied to one character.
- **The review replays from records, not memory.** `askedIndexes` + `givenAnswers` are the session's receipt; the review is a second pass over the receipt. Recording as you go (rather than trying to remember wrong answers in-flight) keeps the session loop simple and the review honest.
- **Statistics read from the receipt too.** `main` recomputes the session's percentage from the returned records rather than asking the session to print it into a global — the data flows home through parameters, which is Unit 08's whole argument.

[← Project 4](project-04-expense-tracker.md) · [Projects home](index.md) · Next: [Project 6 — The Inventory Management System](project-06-inventory.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
