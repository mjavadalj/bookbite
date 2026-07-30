# Technical Architecture

## Purpose

This document defines BookBite's system structure and data flow. Technology selections are defined in `tech-stack.md`; canonical entities and invariants are defined in `domain-model.md`.

## Goals

The architecture must provide:

- offline operation from first launch;
- durable capture without silent data loss;
- responsive UI during OCR, speech transcription, and other background work;
- clear, testable boundaries;
- replaceable external and native services;
- growth without speculative infrastructure or major rewrites.

## Structure

BookBite uses feature-first Clean Architecture. Each feature may contain four layers:

### Presentation

Screens, widgets, navigation state, localization, accessibility semantics, and user feedback.

Presentation depends on application behavior and contains no persistence, text-extraction, catalog, or domain rules.

### Application

Use cases, workflow coordination, background-job orchestration, and presentation-facing state.

Application coordinates domain objects and repository interfaces without depending on concrete storage or service implementations.

### Domain

Canonical entities, value objects, policies, and invariants.

The domain is pure Dart and depends on no Flutter, Riverpod, database, text-extraction, catalog, or platform framework.

### Data

Repositories and adapters for SQLite, files, camera, microphone, text extraction, catalog access, and future services.

Data implements interfaces required by the application or domain.

Dependency direction is inward:

```text
Presentation -> Application -> Domain
                     ^
                     |
                   Data
```

## Modules

MVP modules include:

- Library;
- Catalog;
- Bites;
- OCR;
- SpeechTranscription;
- ReadingCycles;
- ReadingSessions;
- ReadingJourney;
- Progression;
- Settings.

Modules communicate through application/domain interfaces, not each other's storage models.

## Local Data

Local data is the sole MVP source of truth.

- Drift/SQLite stores structured entities, relationships, processing state, and migrations.
- App-private file storage holds source images and voice recordings.
- Database records reference files by managed local identifiers or paths.
- Imported catalog metadata is cached as a local snapshot.

The app must reconcile incomplete writes and orphaned files. Schema changes require versioned, tested migrations. Corruption or migration failure must produce a recoverable state and must not silently reset user data.

Archiving preserves related history. Permanent deletion must be explicit, confirmed, and implemented as a defined cleanup workflow.

## Capture and Text-Extraction Pipeline

Capture is a durable workflow:

1. write the page image or voice recording to a temporary app-private location;
2. move valid source media to its managed location;
3. in one database transaction, reuse the active ReadingSession or create an unassigned session using the capture start time, then create the pending Bite linked to it;
4. complete capture only when the session, Bite, and source media are durable;
5. enqueue persistent on-device OCR or speech-to-text according to the Bite's source kind;
6. expose `captured`, `processing`, `ready`, or `failed` state;
7. store editable text on success;
8. resume incomplete work or expose retry after restart;
9. clean up abandoned temporary or orphaned managed files safely.

Text extraction runs outside the UI thread. Failure must not remove source media or block unrelated interaction.

Opening the Reading Session destination performs no domain write. Manual Start creates a session only when none is active. Capture must not create a second active session.

Voice recording is limited to 30 seconds and is transcribed after recording stops. Canceling or failing before durable capture completes creates no Bite or ReadingSession and removes any temporary or orphaned managed media. An interrupted recording may be saved only when valid audio can be finalized; otherwise the app must explain that it was not saved.

## Reactive Data Flow

```text
SQLite/File/Service Adapters
          -> Repositories
          -> Application Use Cases
          -> Riverpod State
          -> UI
```

The UI observes local state. Network responses and text-extraction results update local data first; the UI reacts to those updates.

## External and Native Boundaries

Define replaceable interfaces for:

- camera capture;
- microphone recording;
- OCR;
- speech-to-text;
- catalog discovery;
- file storage;
- IDs and clock;
- future cloud text extraction and synchronization.

Catalog results must be validated and mapped before entering the domain. Provider IDs and provenance must be retained. Existing PersonalBooks must never require a live catalog lookup.

Native Android/iOS implementations must remain isolated behind Dart interfaces.

## Privacy and Security

- Store personal data and source media only in app-private locations.
- Do not place extracted text, page images, voice recordings, or sensitive metadata in production logs.
- Do not include personal content in analytics or crash payloads.
- Validate media inputs, catalog responses, file references, and database boundaries.
- Keep secrets out of source code and logs.
- Do not upload personal content in the MVP.

## Cross-Cutting Completion Rules

Every feature specification and implementation must define and verify:

- positive, negative, empty, loading, and background states;
- offline and external-service behavior;
- recovery and data-preservation behavior;
- English LTR and Persian RTL;
- accessibility and reduced motion;
- measurable interaction, rendering, and processing performance;
- appropriate unit, widget, integration, migration, and failure tests.

## Future Services

Accounts, cloud backup, synchronization, cloud text extraction, analytics, and remote crash reporting are not part of the MVP.

Future implementations must use optional adapters, preserve local ownership, obtain appropriate user consent, and avoid changing the core domain.
