# MVP Scope

## Goal

The MVP validates one promise:

> Readers can preserve meaningful passages and ideas from physical books without interrupting reading.

It must prove that BookBite can become a natural part of reading through fast, reliable, private, and offline-first Bite capture.

## Success Outcomes

The MVP succeeds when readers can:

- discover or manually create a PersonalBook;
- build and access a local Library;
- track ReadingCycles and ReadingSessions;
- capture a page without first selecting a book;
- receive immediate confirmation that the image is safe;
- obtain editable Bite text through on-device OCR;
- review, edit, assign, and retain Bites offline;
- view a calm ReadingJourney.

Each feature specification must define measurable performance, accessibility, OCR-quality, reliability, and recovery criteria for its part of these outcomes.

## In Scope

### Personal Library

Users can:

- search a free external catalog;
- import a CatalogBook as a PersonalBook;
- manually create a PersonalBook when search is unavailable or has no match;
- access imported metadata offline;
- archive a PersonalBook without losing history;
- view personal reading history for a book.

Open Library is the initial catalog provider and must remain replaceable. Catalog failure must not affect existing PersonalBooks.

### Bite Capture

The complete Bite workflow works offline from first launch:

1. capture a physical-book page;
2. save the source image durably;
3. create a Bite with `captured` status;
4. run free on-device OCR;
5. save editable text or expose a recoverable failure;
6. retain the source image until the user deletes it;
7. assign the Bite now or later.

OCR may continue after capture. The user must be free to resume reading as soon as the image is safe.

English OCR is the primary release-quality target. Persian OCR is included as a secondary MVP priority. The OCR feature specification must define the required accuracy, latency, and test corpus.

### Reading Activity

Users can:

- maintain multiple ReadingCycles for a PersonalBook;
- use the statuses Want to Read, Reading, Paused, Finished, and Dropped;
- start, end, and later assign ReadingSessions;
- optionally use FocusMode during a session;
- capture Bites with or without an active session.

### ReadingJourney

The MVP includes:

- ReadingCycles;
- ReadingSessions;
- Bites;
- a minimal predefined set of milestones, achievements, and ranks.

Progression must remain calm, non-competitive, and secondary to books.

### Localization and Accessibility

The MVP supports English LTR and Persian RTL. Core workflows must support screen readers, dynamic text, accessible contrast and touch targets, correct focus order, and reduced motion.

## Offline and Network Boundaries

Local data is the only MVP source of truth.

Network access is used only for external book discovery. Manual creation is the complete fallback. Existing PersonalBooks, ReadingJourney data, and Bite capture must never require the catalog or internet.

The MVP has no account, backend, cloud backup, synchronization, cloud OCR, or remote user-data store.

## Out of Scope

The MVP does not include:

- AI-generated summaries, refinement, or OCR correction;
- cloud OCR;
- accounts, cloud backup, or cross-device synchronization;
- ebook reading;
- rich-text editing, sticky notes, or highlights;
- tags, folders, or advanced Bite search;
- deep reading analytics;
- personalized recommendations;
- reviews or ratings;
- public profiles, following, comments, clubs, or community features;
- multi-device real-time collaboration.

These capabilities require separate post-MVP decisions and specifications.

## Constraints

Every MVP feature must:

- support the core reading workflow;
- minimize interruption;
- preserve local ownership;
- remain useful offline;
- provide immediate feedback;
- recover without silent data loss;
- support English and Persian;
- meet feature-specific performance and quality criteria.

Technology and progression must remain subordinate to reading.
