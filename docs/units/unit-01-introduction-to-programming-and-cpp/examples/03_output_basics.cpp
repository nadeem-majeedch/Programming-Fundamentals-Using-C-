// 03_output_basics.cpp — Programming Fundamentals Using C++
// Unit 01 · Session 1.2 · cout: chaining, newlines, special characters
// Compile: g++ -std=c++17 -Wall -Wextra 03_output_basics.cpp -o output
// Run:     ./output
//
// PREDICT the output of each block before running. Then modify:
// change a string, re-predict, re-run. That loop IS the lesson.

#include <iostream>

int main() {
    // --- 1. Chaining: one statement, several pieces -------------------
    std::cout << "The answer is " << 42 << "\n";

    // --- 2. \n vs std::endl (same visible output here) ----------------
    std::cout << "Using newline-escape:\n";
    std::cout << "Using std::endl\n" << std::endl;   // extra blank line after

    // --- 3. Tabs and quotes -------------------------------------------
    std::cout << "Name\tMarks\n";
    std::cout << "Ayesha\t91\n";
    std::cout << "He said \"hi\"\n";
    std::cout << "A backslash looks like this: \\\n";

    // --- 4. A small formatted card ------------------------------------
    std::cout << "==== STUDENT CARD ====\n";
    std::cout << "Name : Ayesha Khan\n";
    std::cout << "Year : First\n";
    std::cout << "=======================\n";

    return 0;
}
