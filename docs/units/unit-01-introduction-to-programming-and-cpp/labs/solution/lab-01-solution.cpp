// lab-01-solution.cpp — Lab 01 solution (Programming Fundamentals Using C++)
// Unit 01 · First Program Lab
// Compile: g++ -std=c++17 -Wall -Wextra lab-01-solution.cpp -o lab01sol
// Run:     ./lab01sol
//
// NOTE: this is A solution, not THE solution — any program meeting the
// brief's requirements and the lab rubric is correct. Compare *ideas*, not
// characters. The Debug It fixes are listed at the bottom.

#include <iostream>

int main() {
    std::cout << "==== STUDENT ID ====\n";
    std::cout << "Name     : " << "Ayesha Khan\n";       // chained <<
    std::cout << "Programme: " << "BS Data Science\n";
    std::cout << "Year     : " << "First\n";
    std::cout << "=====================\n";
    return 0;
}

/* ---------------- Debug It fixes (lab-01-debug-it.cpp) ----------------
1.  Missing ';' after the first cout statement
    (std::cout << "==== STUDENT ID ====\n")
    -> the compiler reports expected ';' before 'std::cout' on the NEXT line.
2.  The closing border line is missing an opening quote:
    std::cout << ===================== \n";
    -> produces errors like expected primary-expression; fix:
    std::cout << "=====================\n";
3.  Spelling in the data: "BS Data Sciense" -> "BS Data Science"
    (a wrong-OUTPUT bug: compiles cleanly, prints the wrong thing —
     no compiler message; only comparing with the expected card finds it.)
4.  Border width: the title "==== STUDENT ID ====" is 20 characters, but the
    border in the debug file has 21 '=' characters. The brief requires the
    closing border to be the same width as the title, so fix by counting:
    20 '=' characters. (Like bug 3, this compiles cleanly — it is a
    wrong-output bug that only careful comparison catches.)
------------------------------------------------------------------------ */
