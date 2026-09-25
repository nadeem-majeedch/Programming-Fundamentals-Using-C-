---
title: "STL Mini-Project — The Media Catalogue, Professional Edition"
description: "The Inheritance module's media design re-hosted on STL containers: map-indexed catalogue, multiset leaderboard, algorithm-driven reports, and a written container-choice defence."
---

# STL Mini-Project — the Media Catalogue, professional edition

> [← Module home](index.md) · The course's hand-made machinery, replaced by the library, one piece at a time

## The project in one paragraph

The [Inheritance module's Media Library](../inheritance/miniproject.md) worked — and hand-rolled everything: the guarded `add`, the tally array, the linear find, the hand-sorted report. This edition rebuilds it **on the STL**: `unordered_map` for O(1) lookup, `multiset` for the ranking, the algorithms for every report, lambdas for the orderings. The classes shrink to *policy*; the containers carry the *machinery*.

**Ground rules:**

1. Every container choice carries a **one-sentence justification** (the container-choice defence is graded first).
2. The media hierarchy stays — `MediaItem` abstract base, `Book`/`AudioTrack`/`Film`, `Playable` interface (the Inheritance module's design, unchanged).
3. **No hand-rolled linear searches, no hand-rolled sorts, no hand-rolled tallies** — the algorithms exist; use them.
4. The format contract (`kind;title;creator;extra`) round-trips byte-identically.

---

## Milestone M1 — the catalogue's spine: `unordered_map` + ownership

```cpp
// stl-miniproject.cpp — Programming Fundamentals Using C++
// STL module · Mini-project · The Media Catalogue, professional edition
// Compile: g++ -std=c++17 -Wall -Wextra stl-miniproject.cpp -o miniproject

#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include <set>
#include <map>
#include <algorithm>
#include <numeric>
#include <memory>
using namespace std;

class MediaItem {                        // unchanged from the Inheritance module
public:
    MediaItem(const string& t, const string& c) : title(t), creator(c) {}
    virtual string summary() const = 0;
    virtual string kindName() const = 0;
    const string& getTitle() const { return title; }
    const string& getCreator() const { return creator; }
    virtual ~MediaItem() = default;
private:
    string title, creator;
};

class Playable {
public:
    virtual bool play() const = 0;
    virtual ~Playable() = default;
};

class Book : public MediaItem {
public:
    Book(const string& t, const string& c, int pages) : MediaItem(t, c), pages(pages) {}
    string summary() const override { return to_string(pages) + " pages"; }
    string kindName() const override { return "Book"; }
private:
    int pages;
};

class AudioTrack : public MediaItem, public Playable {
public:
    AudioTrack(const string& t, const string& c, int secs) : MediaItem(t, c), secs(secs) {}
    string summary() const override { return to_string(secs) + " seconds"; }
    string kindName() const override { return "AudioTrack"; }
    bool play() const override { cout << "now playing: " << getTitle() << "\n"; return true; }
private:
    int secs;
};

class Film : public MediaItem, public Playable {
public:
    Film(const string& t, const string& c, int secs, const string& res)
        : MediaItem(t, c), secs(secs), res(res) {}
    string summary() const override { return to_string(secs) + "s, " + res; }
    string kindName() const override { return "Film"; }
    bool play() const override { cout << "now playing: " << getTitle() << "\n"; return true; }
private:
    int secs;
    string res;
};
```

The catalogue's spine replaces the hand-built vector + linear search:

```cpp
class Catalogue {
public:
    // Container choice: unordered_map — the ONLY lookup is "by exact title",
    // no ordering is ever requested, so hash speed wins (Lesson 2's rule).
    bool add(unique_ptr<MediaItem> item) {
        if (!item) return false;
        string key = item->getTitle();
        if (byTitle.count(key)) return false;        // ask-door: no insertion
        byTitle[key] = move(item);                   // the map owns the object
        return true;
    }
    const MediaItem* findByTitle(const string& title) const {
        auto it = byTitle.find(title);
        return it == byTitle.end() ? nullptr : it->second.get();
    }
    int size() const { return (int)byTitle.size(); }
private:
    unordered_map<string, unique_ptr<MediaItem>> byTitle;
};
```

**Explanation.** Two structural upgrades, both earned: (1) the D6/D13 double-free family dies — `unique_ptr` (named honestly as the Pointers/Inheritance modules' ownership rule, automated) makes the map the *sole owner*; the `add` signature takes ownership by value and `move` hands it over. (2) The linear find dies — `find` is O(1) average, and the "no insertion on miss" fix (D1) is baked in via `count` + `find`.

**Exit test:** add five items; `findByTitle` hits and misses; the miss did not grow the map.

## Milestone M2 — the ranking: `multiset` with a comparator

```cpp
    // Container choice: multiset — we need the items ALWAYS ordered by
    // (kind, then title), and duplicates of the pair are possible;
    // the sorted pair's order is structural, not maintained by hand.
    auto cmp = [](const MediaItem* a, const MediaItem* b) {
        if (a->kindName() != b->kindName()) return a->kindName() < b->kindName();
        return a->getTitle() < b->getTitle();
    };
    multiset<const MediaItem*, decltype(cmp)> ordered(cmp);
```

`add` also inserts the raw pointer into `ordered`; the destructor's reverse-iteration erases alongside `byTitle` (the two-structure ownership note from the Inheritance module's M5, now with a one-owner answer: `byTitle` owns, `ordered` **aliases**).

**Exit test:** iterating `ordered` prints items grouped by kind, alphabetical within — zero sort calls anywhere.

## Milestone M3 — the reports: algorithms only

- `playAll()` — collect the `Playable*`s (a `dynamic_cast` probe per item *or* a parallel `vector<Playable*>` maintained at `add`; choose, justify) and play.
- `reportByKind()` — `map<string, int>` counting `kindName()` — the tally, library form.
- `longestPlayingItem()` — `max_element` over a `vector<Playable*>` with a duration comparator (requires a `duration() const` on the interface — the design amendment, documented).
- `averagePagesPerBook()` — walk `ordered`, filter Books with a lambda, `accumulate` seeded `0.0`.

**Exit test:** every report compiles with **no hand-written loop that sorts, searches, or counts** — the algorithms carry them.

## Milestone M4 — persistence (the contract, unchanged)

`save` walks `ordered` (deterministic order — a bonus of M2), writes `kind;title;creator;extra`; `load` parses, builds the right subclass per kind token, `add`s. Byte-identical round trip; malformed lines refuse per the documented policy.

**Exit test:** save → fresh catalogue → load → `listAll` identical.

## Milestone M5 — the container-choice defence (the graded deliverable)

One page, one table, one paragraph:

| Container | Carries | Choice sentence |
| --- | --- | --- |
| `unordered_map<string, unique_ptr<MediaItem>>` | the catalogue | exact-title lookup at O(1); no ordered query exists |
| `multiset<const MediaItem*, cmp>` | the ordered view | always-sorted presentation; structural, not maintained |
| `map<string, int>` | kind histogram | small, needs sorted output, keys tiny |
| `vector<Playable*>` | the playable view | (if chosen) arrival-ordered, aliased, non-owning |
| `priority_queue` (in top-3 report, if added) | the ranking query | top-k under a sort |

The paragraph: **what the STL deleted from your code** — name every hand-rolled mechanism the Inheritance edition carried (linear find, tally array, hand sort, hand ownership) and what replaced each. Then one sentence on what hand-rolling taught that the library couldn't.

## Deliverables checklist

- [ ] Abstract `MediaItem` + three kinds + `Playable`, `override` everywhere
- [ ] `unordered_map` spine with the ownership comment and no-insert ask-door
- [ ] `multiset` ordered view with the comparator lambda and the alias note
- [ ] Reports built on `sort`/`max_element`/`accumulate`/`count_if` — no hand loops for their jobs
- [ ] Byte-identical persistence round trip
- [ ] The container-choice defence: five sentences + the deleted-machinery paragraph

## Reference skeleton

```cpp
class Catalogue {
public:
    bool add(unique_ptr<MediaItem> item);        // owns; refuses duplicates
    bool remove(const string& title);            // erases from BOTH structures
    const MediaItem* findByTitle(const string& title) const;
    void listAll() const;                        // via `ordered`
    void playAll() const;                        // via the playable view
    map<string, int> reportByKind() const;
    ~Catalogue();                                // unique_ptr cleans by itself — write it anyway (empty) and say why
private:
    unordered_map<string, unique_ptr<MediaItem>> byTitle;   // owns
    multiset<const MediaItem*, decltype(cmp)> ordered;      // aliases
};
```

**Three subtleties worth noticing:**

1. `remove` must erase from *both* structures — and the multiset erase needs the same comparator to locate the right node. One owner, two views, synchronized at every mutation.
2. The empty destructor: `unique_ptr` destroys the map's contents automatically — the function exists as a *comment in code* ("the ownership is here, automated"), the Inheritance module's manual loop deleted.
3. `ordered` holds `const MediaItem*` — read-only views into owned objects. Handing out non-const pointers from the map would bypass every door the classes built (the D5/D7 lessons of the Inheritance module, container edition).

## Grading

Self-assessed against the [Project rubric](../grading.md#project-rubrics)'s project row, plus the module's bar: **the container-choice defence is the project**. The code proves the containers work; the defence proves the containers were *chosen*.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
