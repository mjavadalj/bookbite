# Domain Model

## Purpose

This document defines BookBite's canonical concepts, relationships, and invariants. Storage and UI models must adapt to this domain rather than redefine it.

## CatalogBook

A `CatalogBook` is metadata returned by an external book-catalog provider.

Required identity:

- provider;
- provider-specific book or edition ID.

It may include title, authors, edition, language, identifiers, description, and cover references.

A CatalogBook is external data. It never owns reading status, Bites, or ReadingJourney history.

## PersonalBook

A `PersonalBook` is the reader-owned local record for one edition or title.

It has:

- a stable local ID;
- a required title;
- local metadata and timestamps;
- an optional link to a CatalogBook;
- an optional archive timestamp.

A PersonalBook may be created manually and remain independent of every catalog. Imported catalog metadata is stored as a local snapshot so the PersonalBook remains usable offline.

Importing the same provider edition must resolve to the existing PersonalBook. A different edition or translation may create a separate PersonalBook.

Archiving removes a PersonalBook from the active Library without deleting its history. Permanent deletion is a separate confirmed operation whose feature specification must state every related record and file it removes.

## Library

The `Library` is the reader's collection of active PersonalBooks. Archived PersonalBooks remain part of the reader's stored history but are not active Library entries.

## ReadingCycle

A `ReadingCycle` is one attempt to read a PersonalBook.

It has:

- a stable local ID;
- one PersonalBook;
- a start date;
- an optional end date;
- a status;
- timestamps.

Allowed statuses:

- `reading`;
- `paused`;
- `finished`;
- `dropped`.

Rereading the same PersonalBook creates another ReadingCycle.

The PersonalBook's displayed status is derived from its most recent ReadingCycle:

- no cycle: `wantToRead`;
- otherwise: the most recent cycle's status.

## ReadingSession

A `ReadingSession` is a timed period of reading activity.

It has:

- a stable local ID;
- a start time;
- an optional end time;
- a derived duration;
- timestamps;
- an optional PersonalBook and ReadingCycle assignment.

A ReadingSession is active while its end time is absent. At most one ReadingSession may be active.

A session starts only when the reader explicitly starts it or successfully captures source media while no session is active. Opening the Reading Session destination does not create a session. A capture-created session uses the capture start time, may remain unassigned to a book, and can be assigned later.

When assigned to a ReadingCycle, the session's PersonalBook is derived from that cycle.

`FocusMode` is optional distraction-reduced presentation during an active ReadingSession. It is not a separate domain entity.

## Bite

A `Bite` is the canonical captured unit: a meaningful passage or idea preserved from a physical book through a page image or the reader's voice.

It has:

- a stable local ID;
- exactly one source kind: `pageImage` or `voiceRecording`;
- a source-media reference while the image or recording is retained;
- editable extracted text when available;
- a text-extraction status;
- creation and update timestamps;
- optional ReadingSession, PersonalBook, and ReadingCycle assignments.

Allowed text-extraction statuses:

- `captured`: the source media is durable and awaits processing;
- `processing`: on-device OCR or speech-to-text is running;
- `ready`: editable text is available;
- `failed`: processing failed and may be retried.

A Bite may remain unassigned. This is a state of Bite, not a separate entity.

Every newly captured Bite is linked to the active ReadingSession. Capture reuses an existing session or creates one when none is active. A Bite linked to a ReadingSession inherits that session's PersonalBook and ReadingCycle assignment by default. The user may explicitly detach or reassign it.

Source media is retained locally until the user deletes it. Deleting the source image or recording must not delete the Bite's editable text.

## ReadingJourney

`ReadingJourney` is a derived view of the reader's accumulated history:

- PersonalBooks;
- ReadingCycles;
- ReadingSessions;
- Bites;
- milestones;
- achievements;
- ranks.

It supports reflection and personal growth, not competition.

## Milestone, Achievement, and Rank

- A `Milestone` marks meaningful reading progress.
- An `Achievement` recognizes a predefined reading event.
- A `Rank` represents predefined, lightweight progression.

These concepts must remain minimal, extensible, calm, and non-competitive.

## Relationships

```text
Library
└── PersonalBook ── optional link ──> CatalogBook
    └── ReadingCycle
        ├── ReadingSession
        └── Bite

ReadingSession ── optional assignment ──> ReadingCycle
Bite ── optional assignment ──> ReadingSession / ReadingCycle / PersonalBook
```

Assignments may be absent and added later. References must use stable local IDs.

## Invariants

- Catalog data never owns personal data.
- Core records use stable local IDs before any network operation.
- Domain entities do not depend on storage, UI, text-extraction, or catalog frameworks.
- A ReadingCycle belongs to exactly one PersonalBook.
- At most one ReadingSession is active.
- Opening the Reading Session destination never creates a ReadingSession.
- Successful capture creates and links a ReadingSession only when none is active.
- A canceled or failed attempt that does not reach durable capture creates neither a Bite nor a ReadingSession.
- A ReadingSession assigned to a ReadingCycle derives the same PersonalBook.
- A session-linked Bite inherits the session assignment unless explicitly overridden.
- Interrupted text extraction must resume or enter a recoverable failed state after restart.
- Archiving a PersonalBook preserves its ReadingCycles, ReadingSessions, and Bites.

## Terminology

| Use | Meaning | Avoid |
|---|---|---|
| Bite | Captured and editable reading moment | Note, BookNote, Summary |
| CatalogBook | External provider metadata | LibraryBook |
| PersonalBook | Reader-owned edition/title record | Catalog entry |
| ReadingCycle | One attempt to read a PersonalBook | Reading History |
| ReadingSession | One timed reading period | Reading Time |
| FocusMode | Optional focused session UI | ReadingSession |
| Library | Active PersonalBook collection | Catalog |
| ReadingJourney | Derived personal reading history | Analytics dashboard |
