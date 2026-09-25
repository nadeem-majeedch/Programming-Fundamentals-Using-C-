// lab-01-debug-it.cpp — Lab 01 · Debug It (Programming Fundamentals Using C++)
// Unit 01 · This program should print the student ID card correctly,
//            but it contains FOUR seeded bugs.
//
// Compile: g++ -std=c++17 -Wall -Wextra lab-01-debug-it.cpp -o debugit
//
// THE HUNT: read the code first and WRITE DOWN all four bugs before fixing.
// Then fix ONE bug at a time, recompiling after each fix.
// Hints ladder: Lesson 2 §4 -> toolchain/compiler-errors.md -> solution.

#include <iostream>

int main() {
    std::cout << "==== STUDENT ID ====\n"
    std::cout << "Name     : " << "Bilal Ahmed\n";      // BUG?: maybe not...
    std::cout << "Programme: " << "BS Data Sciense\n";  // output looks wrong
    std::cout << "Year     : " << "First\n";
    std::cout << ===================== \n";
    return 0;
}

// BUG DIARY (fill in as you find them):
//   1.
//   2.
//   3.
//   4.
