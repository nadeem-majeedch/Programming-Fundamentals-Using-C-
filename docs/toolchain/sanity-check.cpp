// sanity-check.cpp — Programming Fundamentals Using C++
// Topic : verify that your compiler and command line work (Week 0)
// Compile: g++ -std=c++17 -Wall -Wextra sanity-check.cpp -o sanity-check
// Run    : ./sanity-check            (Windows: .\sanity-check.exe)
//
// You will understand every line of this program during Unit 01 — for now,
// if it compiles and prints the message, your toolchain is ready.

#include <iostream>

int main() {
    std::cout << "My C++ toolchain works!\n";
    std::cout << "Compiler standard: C++17\n";
    std::cout << "Ready for Lesson 1.\n";
    return 0;
}
