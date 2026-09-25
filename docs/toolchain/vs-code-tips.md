---
title: "VS Code Tips"
description: "Set up Visual Studio Code for the course: extension, build task, one-keystroke compile, debugger."
---

# VS Code Tips

> Optional but recommended editor setup · part of the [Toolchain](../getting-started/index.md)

The course only needs a terminal and a compiler. VS Code adds convenience:
highlighted errors as you type, one-keystroke builds, and a graphical
debugger.

## 1. Install the essentials

1. Install [Visual Studio Code](https://code.visualstudio.com/).
2. Install the **C/C++** extension (publisher: Microsoft) — Extensions
   panel (`Ctrl+Shift+X`), search "C/C++".
3. Have a compiler installed already —
   [Windows](../getting-started/compiler-setup/windows.md) ·
   [Linux](../getting-started/compiler-setup/linux.md) ·
   [macOS](../getting-started/compiler-setup/macos.md).

## 2. Open your course folder

`File → Open Folder…` → your `cpp-course` folder. Open a terminal inside it
(`Terminal → New Terminal`) — now the editor and terminal share the folder.

## 3. One-keystroke build (tasks.json)

With any `.cpp` file open, press `Ctrl+Shift+B` → **C/C++: g++ build active
file**. VS Code creates `.vscode/tasks.json` and builds. The first time,
edit the `args` so the build matches the course's flags:

```json
"args": [
    "-std=c++17",
    "-Wall",
    "-Wextra",
    "${file}",
    "-o",
    "${fileDirname}/${fileBasenameNoExtension}"
]
```

`Ctrl+Shift+B` now compiles the file you're viewing; run it in the terminal
(`./hello` or `.\hello.exe`). Don't have `Ctrl+Shift+B` offering the g++
option? The compiler isn't on your PATH — revisit your OS setup guide.

<a name="4-debugging-with-f5"></a>
## 4. Debugging with F5

Press `F5` → **C/C++ (GDB/LLDB)** → **g++ build and debug active file**.
Click left of a line number to set a **breakpoint**, press `F5`, and:

- **F10** — step over a line
- **F11** — step into a function
- the **Variables** pane shows every local variable's value live

Watching a variable change line by line is the single fastest way to
understand loops (Unit 05) and pointers (Unit 13). The optional
[gdb walkthrough](gdb-walkthrough.md) covers the terminal equivalent.

## 5. Small quality-of-life settings

```json
{
    "files.autoSave": "onFocusChange",
    "editor.tabSize": 4,
    "editor.renderWhitespace": "selection"
}
```

## 6. Warnings are your friends

The course compiles with `-Wall -Wextra`. In VS Code the same warnings show
as yellow squiggles — fix them as they appear and your Debug It exercises
get much easier.

---

*[← Toolchain](../getting-started/index.md) · [Compiler errors](compiler-errors.md) · [FAQ](../faq.md)*
