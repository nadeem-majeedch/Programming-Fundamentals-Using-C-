// lab-00-debug-it.cpp — Lab 00 · Part 2 (Programming Fundamentals Using C++)
// This program SHOULD print a poster, but it contains FOUR seeded bugs:
// two stop compilation, one stops linking, and one prints the wrong thing
// without any compiler complaint.
//
// Compile: g++ -std=c++17 -Wall -Wextra lab-00-debug-it.cpp -o debug00
//
// THE HUNT: read first; write down all 4 bugs BEFORE fixing. Then fix ONE
// bug at a time, recompiling after each. Classify each bug afterwards:
// compile error / linker error / logic (wrong output).
// Hint ladder: lesson §16 -> getting-started-troubleshooting.md -> catalogue.

#include <iostream>

int Main() {                                  // hmm.
    std::cout << "=========================\n"
    std::cout << "|   Bilal Ahmed         |\n";
    std::cout << "|   Lhr, BS Data Sience |\n";    // something's off in the output
    std::cout << "|                       |\n";
    std::cout << =========================  \n";
    return 0;
}

// BUG DIARY (fill in as you find them — kind, how found, fix):
//   1.
//   2.
//   3.
//   4.
