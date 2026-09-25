// 02_anatomy.cpp — Programming Fundamentals Using C++
// Unit 01 · Session 1.2 · The same program as 01_hello.cpp, annotated
// Compile: g++ -std=c++17 -Wall -Wextra 02_anatomy.cpp -o anatomy
// Run:     ./anatomy
//
// Output is identical to 01_hello.cpp — the comments are the lesson.

#include <iostream>   // bring in the input/output library (cout needs it)

// int main() — every C++ program starts here.
// int        — main hands a whole number back to the operating system
// ()         — main takes no inputs in this course's early units
// {          — opens main's body ...
int main() {
    std::cout << "Hello, world!\n";   // send text to the console; \n = newline
    return 0;                         // 0 = "finished normally" (convention)
}                                     // ... and } closes main's body
