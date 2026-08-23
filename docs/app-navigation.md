# App Navigation

## Purpose

This document defines BookBite's MVP-wide navigation: main destinations, global Bite capture behavior, cross-feature routes, back behavior, and restoration.

Feature specifications own their internal screens, parameters, states, and edge cases.

## Principles

Navigation must be simple, predictable, offline-capable, accessible, and natural in English LTR and Persian RTL.

The reader must always know:

- where they are;
- how to return;
- whether an action succeeded or changed context.

## Launch

Reading Session is the default launch destination.

On launch:

- show the active ReadingSession when one exists;
- otherwise show the Reading Session root in its idle state with Start, Photo, and Voice available;
- never create or start a ReadingSession merely because the destination opened.

The reader may start a session explicitly without choosing a PersonalBook. If no session is active, successfully capturing a photo or voice recording starts an unassigned session automatically and links the Bite to it.

Returning from the background preserves the current context. An explicit valid route may open its target directly.

## Main Destinations

The MVP has five main destinations:

1. **Reading Session**
2. **Library**
3. **Discover**
4. **Journey**
5. **Settings**

| Destination | Owns |
|---|---|
| Reading Session | Photo and Voice capture, start/resume/end session, FocusMode, session Bites |
| Library | Active PersonalBooks, PersonalBook details, related cycles, sessions, and Bites |
| Discover | Catalog search, CatalogBook overview, import, and manual PersonalBook creation |
| Journey | Private ReadingJourney, cycles, sessions, Bites, milestones, achievements, and ranks |
| Settings | Language, reduced motion, local text extraction, and general app preferences |

Switching destinations preserves their current navigation stacks. Selecting the active destination again returns to its root.

The MVP has no Profile, account, synchronization, cloud text-extraction, public identity, social, or deep-analytics destination.

## Bite Capture

Photo and Voice are available from every main destination and eligible child route. They have equal visual weight and differ only by capture method:

- Photo captures a page image for OCR.
- Voice records up to 5 seconds for speech-to-text.

Reading Session and FocusMode present both as the two primary actions. Other eligible routes present both as compact actions in the bottom navigation area. Neither action is a destination or replaces the current navigation stack.

CatalogBook overview and focused catalog search do not expose Photo or Voice. These routes prioritize evaluating or locating a catalog record. Back or Cancel returns to the Discover root, where both capture actions remain available.

Capture opens above the current context. Voice capture shows recording state and elapsed or remaining time, permits Stop or Cancel, and stops automatically at 5 seconds. Cancel creates no Bite. Microphone denial shows a localized explanation and access to system settings without affecting Photo.

Capture reuses the active ReadingSession. If none exists, durable capture creates one using the capture start time. Canceling or failing before durable capture completes creates neither a Bite nor a ReadingSession.

After source media is durably saved, the user may:

- return to the previous context while text extraction continues; or
- open Bite detail to review processing state or edit available text.

Navigation must support assigned and unassigned Bites. Assignment rules belong to the Bite feature specification.

## Cross-Feature Routes

```text
Reading Session
├── Photo / Voice ──> Start or reuse session ──> Bite Detail
├── Start / Resume ──> Active Session
└── Active Session ──> FocusMode / Session Bites / End

Library
├── Add PersonalBook ──> Discover / Manual Creation
└── PersonalBook Details ──> ReadingCycle / ReadingSession / Bite Detail

Discover
├── Catalog Search ──> CatalogBook Overview
└── Import / Manual Creation ──> PersonalBook Details

Journey
└── ReadingCycle / ReadingSession / Bite Detail / Progression

Settings
└── Local Application Preferences

Any eligible context ──> Photo / Voice
```

After creating or importing a PersonalBook, open its details and update Library.

CatalogBook overview and PersonalBook details must remain distinct: one represents external metadata; the other represents the reader's local relationship with a book.

Ending a ReadingSession returns to the Reading Session root. The completed session remains available in Journey and, when assigned, its PersonalBook.

Discover must offer manual creation when offline or when catalog search fails. Existing PersonalBooks and all other main destinations must remain usable without network access.

## Back and Dismiss

Back navigation:

1. dismisses the current dialog, sheet, capture surface, or transient editor;
2. pops the current child route;
3. remains at the current destination root;
4. allows the operating system to leave the app from a root destination.

Leaving an incomplete workflow requires confirmation only when unsaved input would be lost. A durably captured Bite is saved even while text extraction is pending.

Returning from Bite detail restores its originating context when that context still exists.

## Restoration and Invalid Routes

The app must restore:

- an active or unfinished ReadingSession;
- an interrupted capture or editor when safe;
- pending Bite processing state.

If none applies, launch at Reading Session.

When a route references missing, archived, or deleted data, show a localized recovery state and return to the nearest valid destination. Navigation failure must never reset or delete user data.

## Feature-Specification Contract

Each feature specification must define:

- routes it owns and their parameters;
- entry, exit, and confirmation behavior;
- empty, loading, error, offline, and restoration states;
- accessibility, focus, RTL, and reduced-motion behavior;
- approved links to other features.

Adding a main destination or changing global Photo or Voice behavior requires product approval.
