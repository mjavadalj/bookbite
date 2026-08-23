# Feature Specification: Library

**Status:** Approved
**Feature owner:** Library  
**MVP platform:** Android, preserving future iOS compatibility  
**Last updated:** 2026-08-11

## 1. Purpose

Library is the reader’s calm, personal view of their books in BookBite.

The MVP provides a simple, fully offline way to:

- view active `PersonalBook`s;
- add another book through Discover; and
- open a selected book through the future PersonalBook Detail route.

Library should feel warm, friendly, and personal without becoming a progression dashboard or complex bookshelf simulation.

## 2. Scope

### In scope

- Library root at `/library`;
- active local `PersonalBook`s;
- vertically scrollable, spine-inspired bookshelf;
- Add Book navigation to Discover Active Search;
- book-selection route handoff;
- loading, empty, populated, and recoverable error states;
- offline use and scroll restoration;
- English LTR, Persian RTL, accessibility, large text, and reduced motion.

### Out of scope

- Library search, filters, categories, or sorting controls;
- PersonalBook Detail content;
- importing, manual creation, editing, archiving, or deletion workflows;
- reading progress, streaks, achievements, ranks, or milestones;
- functional decorations, room customization, themes, or atmosphere changes;
- Profile, accounts, notifications, social features, or analytics;
- changes to the existing app shell, bottom navigation, Photo, or Voice actions;
- pixel-perfect reproduction of the supplied reference.

Linked features own their behavior. Library owns only its root experience and outgoing navigation.

## 3. Fixed MVP decisions

1. Library shows only active `PersonalBook`s. Archived books remain stored but are excluded.
2. Local storage is the sole source of truth. Library makes no network or catalog request.
3. Books are ordered by creation time, newest first.
4. Library is one vertically scrollable page with no page-level horizontal scrolling.
5. The physical-shelf metaphor stays simple. Readability takes priority over realism.
6. The existing Sage and Paper theme and shared components must be reused.
7. Library has no search. Add Book opens Discover Active Search with an empty query.
8. Selecting a book passes its stable local ID to the PersonalBook Detail route.
9. Library uses the existing `AppShell` and does not render or redesign bottom navigation.
10. The existing destinations remain Reading Session, Library, Discover, Journey, and Settings. Global Photo and Voice behavior remains unchanged.

## 4. Data contract

Library observes active PersonalBook summaries from local storage.

Each summary needs only:

- stable local PersonalBook ID;
- required title;
- optional display author;
- creation timestamp.

The data updates reactively when another feature creates or archives a PersonalBook. Database and catalog-provider types must not leak into the Library UI.

Library presentation has four states:

- initial loading;
- empty;
- populated;
- recoverable local-read error with Retry.

Retry must never modify, reset, or delete personal data.

## 5. MVP experience

### Page structure

The Library body contains:

1. a compact localized Library heading;
2. one visible Add Book action;
3. the empty state or scrollable bookshelf.

The page uses the safe content area provided by the existing app shell. It must not duplicate or overlap the bottom navigation.

### Bookshelf

- Books appear as simple, selectable, spine-inspired items on shelf rows.
- The shelf scrolls vertically and builds off-screen items lazily.
- Every book title remains readable.
- Optional author text may be omitted when space is limited.
- Long and mixed-direction titles truncate or wrap predictably.
- Persian and large-text layouts may simplify the spine treatment instead of rotating unreadable text.
- Styling uses shared Sage and Paper tokens.
- No detailed room illustration or decorative asset set is required for MVP.

### Add Book

Add Book opens Discover Active Search with an empty, focused search field.

Discover owns catalog search, provider failures, offline cached search, and manual creation. Library does not duplicate those workflows.

When a book is added elsewhere, Library updates from local storage and places the new book near the beginning of the shelf.

### Open Book

Selecting a book invokes the PersonalBook Detail route with its stable local ID.

Library owns only tap feedback and navigation handoff. PersonalBook Detail owns the destination page, history, cycles, sessions, Bites, editing, archiving, and missing-record behavior.

Until PersonalBook Detail is implemented, this handoff may be tested with a route fake. No placeholder detail UI is required.

## 6. States

### Loading

Show a lightweight placeholder inside the Library content area. Keep the app shell usable.

### Empty

Show a welcoming empty shelf, short localized guidance, and Add Book. Do not use progression, rewards, or urgency.

### Populated

Show the ordered, vertically scrollable bookshelf and Add Book.

### Error

Show a concise localized explanation and Retry. Do not imply that books were deleted.

### Offline

Offline is normal Library behavior. Existing PersonalBooks remain visible and selectable.

### Restoration

Restore the previous valid scroll position after child navigation, switching main destinations, or normal app restoration.

## 7. Accessibility and localization

- Localize all visible and semantic text in English and Persian.
- Support natural LTR and RTL layout, alignment, shelf order, and focus order.
- Give every book and Add Book a localized semantic label and button role.
- Use touch targets of at least 48dp.
- Use accessible contrast through existing semantic tokens.
- Support large text without page-level horizontal scrolling.
- Do not convey meaning only through spine color, orientation, decoration, or motion.
- Keep motion brief and functional.
- Respect reduced-motion settings.

## 8. Performance and privacy

- Begin visible input feedback within 100 ms under normal load.
- Build off-screen books lazily.
- Keep scrolling responsive with a large local collection.
- Never delay Library for catalog requests or image downloads.
- Never upload personal Library data.
- Do not include titles, authors, local IDs, or other personal metadata in production logs.

## 9. Future visual direction

The supplied reference image is the long-term visual aspiration for Library: calm, warm, friendly, personal, and reminiscent of a physical reading space.

Future separately approved work may add:

- richer bookshelves;
- environmental illustration;
- plants and personal objects;
- lighting and atmosphere;
- personalization or earned decorations;
- a more immersive room-like composition.

These are not MVP requirements, dependencies, or acceptance criteria.

The MVP should keep a simple structure—heading, shelf, book item, and Add Book action—so its presentation can become richer later without changing the PersonalBook domain model.

Do not create decoration models, progression services, theme infrastructure, or unused extension points now.

The reference image’s bottom navigation, profile, notifications, and progress widgets are not design requirements. BookBite’s actual navigation remains authoritative.

## 10. Acceptance criteria

### Active collection

Given active and archived PersonalBooks, when Library opens online or offline, it shows only active books in newest-first order without making a catalog request.

### Empty state

Given no active PersonalBooks, when Library opens, it shows the welcoming empty state and Add Book action.

### Add Book

When Add Book is selected, Library opens Discover Active Search with an empty, focused search field.

### Reactive updates

When another approved workflow creates or archives a PersonalBook, the shelf updates from local storage without a network refresh.

### Book selection

When a book is selected once, Library provides immediate feedback and invokes the PersonalBook Detail route once with the correct local ID.

### Error recovery

When the local query fails and Retry later succeeds, Library displays the recovered collection without changing stored data.

### Restoration

When the reader returns to Library, the prior valid scroll position is restored.

### Navigation ownership

In every Library state, the existing bottom navigation and global capture controls remain unchanged and no duplicate navigation is rendered.

### Inclusive use

English, Persian, large text, reduced motion, and screen-reader users can understand and activate every book and action without relying on the visual spine treatment.

## 11. Verification

Test:

- active-only filtering and newest-first ordering;
- loading, empty, populated, and error states;
- reactive creation and archiving updates;
- Add Book navigation;
- PersonalBook route handoff;
- long titles and long-list scrolling;
- offline behavior;
- scroll restoration;
- English LTR and Persian RTL;
- semantics, focus order, 48dp targets, contrast, and large text;
- reduced motion;
- absence of catalog requests and personal metadata in logs.

Tests use local fakes and fixtures and never depend on live Open Library.

## 12. Completion gate

The Library MVP is complete when:

- all acceptance criteria pass;
- local books remain available offline;
- Add Book and PersonalBook route handoffs are verified;
- the existing app shell and capture behavior remain unchanged;
- accessibility, localization, restoration, and privacy are verified;
- no progression, decoration system, PersonalBook Detail UI, or other deferred feature is implemented as part of Library.
