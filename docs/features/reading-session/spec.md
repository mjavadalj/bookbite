# Feature Specification: Reading Session

**Status:** Approved
**Last updated:** 2026-08-18

## 1. Purpose

Reading Session gives the reader a calm place to choose a local book, confirm the choice, start or continue reading, capture Bites, and end the timed session.

The MVP presentation is intentionally approximate. It uses the supplied HTML as visual direction while the core specifications and Sage and Paper design system remain authoritative.

## 2. Scope

### In scope

- idle Start a session page;
- local Library search and book selection;
- selected-book confirmation;
- explicit assigned or unassigned session start;
- active assigned or unassigned session;
- active-session assignment;
- compact page-image Bite thumbnails and extraction states;
- End session confirmation;
- offline operation, restoration, localization, RTL, and accessibility;
- Photo handoff to the Capture Bite feature.

### Out of scope

- FocusMode;
- page counters, reading percentages, and progress editing;
- changing a ReadingCycle to paused, finished, or dropped;
- Bite deletion or reassignment;
- global catalog search or PersonalBook creation;
- exact reproduction of the mockup.

These exclusions are limited to this slice. They do not remove later MVP obligations from the core specifications.

## 3. Fixed Decisions

1. Opening Reading Session or selecting a PersonalBook creates no ReadingCycle or ReadingSession.
2. Local storage is the only data source; this feature performs no network request.
3. At most one ReadingSession is active.
4. The active session always wins over stale picker or confirmation navigation.
5. A reader can start without a book.
6. Camera and five-second Voice capture are available and use the shared durable Bite pipeline.
7. Add a new book is visible but disabled with localized helper text.
8. End session ends only the timed session; it does not finish or pause its ReadingCycle.
9. Small Bite thumbnails communicate status but do not open an editor in this slice.

## 4. Routes and Navigation

| Route | State | Behavior |
|---|---|---|
| `/reading-session` | No active session | Idle picker |
| `/reading-session` | Active session | Active-session page |
| `/reading-session/book/:personalBookId` | Valid active book | Confirmation page |
| `/reading-session/capture/photo` | Eligible origin | Full-screen Capture Bite page above the current context |

The generated typed router must use stable local IDs and restoration identifiers.

Entry and exit rules:

- App launch opens `/reading-session`.
- Back from confirmation restores the picker query and scroll position.
- Back from the active destination root follows normal operating-system behavior and does not end the session.
- Capture Cancel restores its originating Reading Session state.
- Durable capture returns to the active-session page, including when capture created that session.
- Confirmed End returns to the idle picker.
- Selecting the active bottom destination again returns to the root without ending an active session.

Invalid routes:

- A missing or archived PersonalBook shows localized recovery and returns to the idle picker.
- If a session becomes active while confirmation is open, Start/Continue is replaced by a route to that active session; no second session is created.
- Navigation failure never resets or deletes local data.

## 5. Data and Application Contracts

### Picker projection

The picker observes active PersonalBook summaries containing:

- stable PersonalBook ID;
- title and optional display author;
- optional local cover reference or deterministic fallback;
- derived latest ReadingCycle status;
- optional most recent completed session time.

Archived books are excluded. Results update reactively when local data changes.

### Session summary

The active page observes:

- session ID, start time, and optional assignment;
- derived elapsed duration from the injected clock;
- assigned book identity when present;
- compact Bites ordered newest first;
- each Bite's stable ID, thumbnail reference, and extraction status.

The timer is presentation-derived and must not write every tick.

### Required operations

Application-facing operations must support:

- `startAssigned(personalBookId)`;
- `startUnassigned()`;
- `assignActiveSession(personalBookId)`;
- `endActiveSession()`;
- observation of the active session and its Bites;
- retry handoff for a failed page-image Bite.

Names may follow project conventions, but behavior and atomicity are fixed. Presentation must not coordinate repositories directly.

## 6. ReadingCycle and Start Rules

| Latest PersonalBook state | Label | Confirmed behavior |
|---|---|---|
| No ReadingCycle | Start reading | Create a new `reading` cycle and assigned session atomically |
| `reading` | Continue reading | Reuse that cycle and create an assigned session |
| `paused` | Continue reading | Set that cycle to `reading` and create the session atomically |
| `finished` | Start reading | Create a new `reading` cycle for rereading and the session |
| `dropped` | Start reading | Create a new `reading` cycle and the session |

If another active session exists, every start operation returns the existing-session result and creates no new cycle or session.

`startUnassigned` creates only a ReadingSession. Assignment later applies these rules using the selected book and updates the session's assignment atomically. Existing session-linked Bites that still inherit the session assignment receive the same assignment; explicitly overridden Bites remain unchanged.

## 7. Page Experience

### 7.1 Idle picker

Page order:

1. Back behavior supplied by the destination context, when applicable;
2. localized Start a session heading and short guidance;
3. labeled Search your library field;
4. active local books;
5. subtle Start without a book;
6. compact Camera and disabled Voice actions;
7. disabled Add a new book with persistent unavailable helper.

Search rules:

- trim surrounding whitespace;
- match title or author case-insensitively using locale-safe normalization available to the app;
- filter in local application state for the MVP;
- preserve query and scroll position across confirmation and normal restoration;
- show a distinct no-results state without implying the Library is empty.

### 7.2 Selected-book confirmation

Show the chosen cover/fallback, title, author, derived reading status, and an optional concise previous-session summary. Omit page number and progress percentage.

The primary action is Start reading or Continue reading according to section 6. Camera and disabled Voice remain compact near the bottom. FocusMode is absent.

Selection and page rendering are read-only. The primary action shows immediate progress feedback, disables duplicate submission, and writes only after explicit activation.

### 7.3 Active session

Show:

- Reading session heading and text-labeled active status;
- assigned book identity or a clear No book selected state;
- elapsed session time;
- compact newest-first Bite strip;
- Assign book when unassigned;
- large Camera action in the former Start/Continue position;
- large disabled Voice action in the former FocusMode position;
- End session as the last action in the former compact-capture area.

The transition may use a brief 150-300ms position/emphasis animation only when it preserves spatial continuity and does not shift surrounding content unpredictably. Reduced motion changes state without animation.

End session opens a localized confirmation dialog. Cancel leaves the session active. Confirm records one end timestamp, is idempotent, and returns to idle. Failure keeps the session visible and offers Retry.

### 7.4 Compact Bites

- Use small lazy-built thumbnails with a non-color status label or semantic equivalent.
- `captured` and `processing` remain visibly pending without urgency.
- `ready` confirms completion.
- `failed` explains that the image is safe and exposes Retry with a minimum 48dp target.
- A retry changes status through local persisted state; it never creates another Bite.
- Thumbnail activation has no detail/edit action in this slice.

## 8. States and Recovery

| State | Required presentation and behavior |
|---|---|
| Loading | Lightweight local placeholder; shell remains usable |
| Empty Library | Guidance, Start without a book, Camera, disabled Voice, disabled Add |
| No search results | Keep query visible; Clear search; no catalog request |
| Local read failure | Explain that data was not deleted; Retry performs a read only |
| Missing/archived selection | Recovery message and return to picker |
| Start conflict | Open the existing active session |
| Start/end failure | Keep current durable state and allow Retry |
| Offline | Normal behavior; no offline warning is needed |
| Background/return | Recompute elapsed time and observe persisted state |
| Process restart | Restore the active session and its Bite statuses from local storage |

## 9. Presentation and Accessibility

- Reuse semantic Sage and Paper tokens, shared components, and one consistent vector icon family.
- Use a simple single-column phone layout that adapts to landscape, tablet width, and large text without horizontal scrolling.
- Fixed actions respect system and app-shell safe areas; scroll content is never obscured.
- Every action has a native button role, visible press feedback, and at least a 48dp target with 8dp separation.
- Disabled Add, Voice, and future controls use reduced emphasis, disabled semantics, and nearby localized explanation; they never appear tappable.
- Provide 4.5:1 normal-text contrast and 3:1 large-text/non-text contrast through existing semantic tokens.
- Do not communicate active or extraction state using color alone.
- Screen-reader focus follows visual order and moves to the page heading after route changes.
- Localize visible, semantic, error, status, duration, and confirmation strings in English and Persian.
- Mirror direction-sensitive layout/icons in RTL while keeping mixed-direction titles readable.

## 10. Performance and Privacy

- Cached local picker content becomes usable within 200ms p95 after route construction on the approved reference device.
- Search/filter feedback appears within 100ms p95 for 1,000 active books.
- Start, assign, and end actions show feedback within 100ms and complete local persistence within 500ms p95, excluding injected test delays.
- Long book and Bite lists build lazily and target 60fps scrolling.
- Logs exclude book queries, titles, authors, session metadata, image references, and extracted content.

## 11. Acceptance Criteria

### RS-01 — Read-only entry

Opening the root or confirmation route, searching, and selecting a book create no cycle or session.

### RS-02 — Local picker

Active books can be searched by local title/author online or offline; archived books and catalog requests are absent.

### RS-03 — Start rules

Each latest-cycle state produces the specified label and atomic cycle/session result, including rereading and paused continuation.

### RS-04 — Single active session

Concurrent or stale starts produce at most one active session and do not leave an extra cycle.

### RS-05 — Unassigned lifecycle

The reader can start unassigned, later assign the active session, and preserve compatible Bite inheritance.

### RS-06 — Active control replacement

Camera and disabled Voice occupy the large action positions; End session is last; FocusMode, page counters, and percentages are absent.

### RS-07 — End behavior

Canceling confirmation preserves the active session; confirming ends it once and leaves its ReadingCycle unchanged.

### RS-08 — Bite status

Compact Bites react to persisted extraction changes, and failed Bite Retry does not duplicate data.

### RS-09 — Recovery and restoration

Missing records, local failures, backgrounding, process restart, and invalid routes preserve data and reach a valid state.

### RS-10 — Inclusive presentation

English LTR, Persian RTL, large text, screen readers, keyboard/accessibility traversal, contrast, safe areas, and reduced motion meet section 9.

### RS-11 — Performance and privacy

Section 10 budgets pass and protected personal metadata is absent from production diagnostics.

## 12. Verification and Completion Gate

Test:

- pure-Dart label, cycle, assignment-inheritance, duration, and single-active policies;
- application start/assign/end idempotency, conflict, and failure behavior;
- Drift repository queries, atomic writes, constraints, and migration behavior;
- Riverpod loading, empty, populated, error, restoration, and reactive Bite states;
- widget routes, search, button replacement, disabled controls, dialog, and invalid records;
- integration flows for assigned/unassigned start, capture-created session, multiple captures, assignment, restart, Retry, and End;
- accessibility semantics, focus, 48dp targets, LTR/RTL, large text, landscape, tablet, and reduced motion;
- performance budgets and privacy-safe logs.

Use checked-in fakes and deterministic clocks/IDs. The specification is ready for approval only when it remains consistent with Capture Bite and all review blockers are resolved. Implementation is complete later only when RS-01 through RS-11 pass.
