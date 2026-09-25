---
title: "OOP Mini-Project — The Media Library"
description: "A polymorphic media catalogue: abstract base, three media kinds, an interface for playable items, persistence with a format contract, and a written design defence."
---

# OOP Mini-Project — the Media Library

> [← Module home](index.md) · The inheritance module's capstone · Built on the [five labs](labs.md) and every habit since Unit 05

## The project in one paragraph

A media catalogue manages **books** (page count), **audio tracks** (duration), and **films** (duration, resolution) — every item answers `summary()`, playable items additionally answer `play()`, the catalogue lists everything with **one loop**, loads and saves a **text format**, and computes per-kind statistics. The design is the deliverable: an abstract `MediaItem` base, a `Playable` interface on the items that deserve it, a composed `Catalogue` — and a **written design defence** explaining every relationship, in the format the [design reviews](design.md) established.

**Ground rules:**

1. **Every relationship passes the is-a test in a written sentence.** The defence document is graded first.
2. **No type fields, no `dynamic_cast`, no switches on kind** — the loop and the interfaces are the whole dispatch.
3. The **format contract** (`type;title;creator;extra` — your documented field per kind) round-trips byte-identically.
4. Every polymorphic base has a **virtual destructor** — the rule with no exceptions, enforced by the [checklist](#deliverables-checklist).
5. Raw pointers imply ownership comments; nothing is owned twice.

---

## Milestone M1 — the abstract base

`MediaItem` (title, creator — both private, set at birth): pure `summary() const -> string`, pure `kindName() const -> string`, virtual destructor, shared non-virtual `describe()` calling both hooks. Verify: instantiation is a compile error; the error names the pure virtuals.

**Exit test:** `MediaItem m;` refuses; `describe()` prints "kind — summary" for any subclass.

## Milestone M2 — the three kinds

- `Book : MediaItem` — page count; `summary` mentions pages; `kindName` returns "Book"
- `AudioTrack : MediaItem` — duration seconds, **implements `Playable`** (Lesson 3's idiom 1)
- `Film : MediaItem` — duration, resolution; **implements `Playable`**
- `Playable` — pure `play() const -> bool` (prints "now playing: title", returns true), virtual destructor
- `Book` does **not** implement `Playable` — and a `playAll(const vector<Playable*>&)` loop must refuse it *by type*, not by a flag

**Exit test:** a mixed `vector<MediaItem*>` lists all three; a `vector<Playable*>` holds track + film only — and the compile attempt to add a Book there **fails**, which is the test.

## Milestone M3 — the catalogue (composition owns the family)

`Catalogue`: **has-a** `vector<MediaItem*>` (owns every item), `add(MediaItem*) -> bool` (refuses `nullptr` and duplicate title+creator pairs — the invariant from the OOP module's roster), `listAll() const`, `countByKind() const` (per-kind tally via `kindName()` — the Algorithms module's tally, keyed by contract), destructor deletes every item. The ownership contract sits in a comment at the class head (C9's format).

**Exit test:** add 5 items (2 books, 2 tracks, 1 film); `listAll` prints 5; `countByKind` prints 2/2/1; catalogue destruction shows **five** destructor runs in reverse order (Lesson 1's death order, observed).

## Milestone M4 — persistence (the contract)

- `save(const string& file) const` — one line per item: `kindName();title;creator;extra` where extra is page count or duration(+resolution); the open-check pattern; the format documented *above the function as the contract*
- `load(const string& file) -> bool` — open-check, parse, **build the right subclass per line's kind field** (the registry idea from C7, at mini scale: a small if/else over *the format's own kind token* is honest here — the format file, not a program enum, is the dispatch key), validate, `add`
- Round-trip requirement: save → load into a *fresh* catalogue → listAll output identical

**Exit test:** byte-identical round trip; a malformed line refuses the load with a named message (your documented policy).

## Milestone M5 — the playlist (interfaces at work)

- `playAll()` on the catalogue: builds a temporary `vector<Playable*>` of exactly the playable items and runs the play loop — **without any cast** (keep a parallel owned collection, or give the catalogue a second interior vector maintained at `add` time; choose, document the ownership)
- Statistics: total play time of playable items; average pages per book

**Exit test:** `playAll` plays track + film only; adding a new playable kind (⭐ extension) needs zero changes here.

---

## The design defence (the graded deliverable)

One page, in this order:

1. **Relationship table** — every relationship in the design as a row: *sentence (is-a/has-a), test result, alternative considered, why kept.* Expected rows at minimum: Book is-a MediaItem; AudioTrack is-a MediaItem; AudioTrack is-a Playable (interface — stateless contract); Film is-a Playable; Book is-*not*-a Playable (the test that *fails*, written out); Catalogue has-a collection of MediaItem (composition — ownership stated); Catalogue has-a collection of Playable (aggregation or derived — your M5 choice, defended).
2. **The abstract-base argument** — why `MediaItem` is abstract, what would go wrong (concretely: which lies become printable) if `summary()` had a default body.
3. **The destructor sentence** — which deletions happen through which base pointers, and why every one of them needs `virtual`.
4. **The format contract** — the field table and the amendment procedure (what happens to old files when Film gains a field — the Files module's contract-amendment honesty, one last time).
5. **The composition confession** — one paragraph on the *one* place composition replaced an inheritance you initially sketched (if none: find one — the parallel Playable collection is the usual candidate), and what the swap bought.

## Deliverables checklist

- [ ] Abstract `MediaItem` + three kinds + `Playable`, all with `override` keywords
- [ ] Catalogue with ownership comment, invariants, observed reverse-order destruction
- [ ] Round-tripping format contract with documented amendment policy
- [ ] `playAll` with zero casts and type-based admission of playable items
- [ ] The design defence, five sections, sentences spoken aloud
- [ ] Test table: abstract refusals, duplicate refusal, cap invariants, round trip, malformed-line policy, play loop

## Reference skeleton

```cpp
class MediaItem {                    // abstract — the catalogue's contract
public:
    MediaItem(const string& title, const string& creator);
    virtual string summary() const = 0;
    virtual string kindName() const = 0;
    void describe() const;           // shared: "kind — summary"
    virtual ~MediaItem() = default;
private:
    string title, creator;
};

class Playable {                     // interface — stateless, capability-named
public:
    virtual bool play() const = 0;
    virtual ~Playable() = default;
};

class Catalogue {                    // owns every MediaItem added
public:
    bool add(MediaItem* item);       // takes ownership; refuses nullptr/duplicates
    ~Catalogue();                    // deletes all — in reverse order
private:
    vector<MediaItem*> items;
    vector<Playable*> playable;      // M5's choice — ownership stays with `items`
};

int main() {
    Catalogue cat;
    // add -> listAll -> save -> (fresh Catalogue) -> load -> playAll -> stats
}
```

**Three subtleties worth noticing:**

1. The catalogue owns items **once** — the `playable` vector holds *aliases* into the same objects (non-owning pointers). Write which vector deletes, and why the other must not (the Pointers module's ownership rule, two collections wide).
2. `load`'s kind-token dispatch builds subclasses — the *only* if/else on kind in the whole program, justified by the format being the dispatch key. Locate and defend it.
3. `describe()`'s output concatenates two virtual calls — the template-method skeleton at its smallest; verify each item's line differs in both parts.

## Grading

Self-assessed against the [Project rubric](../grading.md#project-rubrics)'s project row — plus the module's own bar: **the defence document is the project**. The code proves the design compiles; the defence proves the design is *chosen*.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
