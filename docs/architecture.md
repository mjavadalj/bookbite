# Technical Architecture

## Purpose

This document defines BookBite's system structure and data flow. Technology selections are defined in `tech-stack.md`; canonical entities and invariants are defined in `domain-model.md`.

## Goals

The architecture must provide:

- offline operation from first launch;
- durable capture without silent data loss;
- responsive UI during OCR and other background work;
- clear, testable boundaries;
- replaceable external and native services;
- growth without speculative infrastructure or major rewrites.

## Structure

BookBite uses feature-first Clean Architecture. Each feature may contain four layers:

### Presentation

Screens, widgets, navigation state, localization, accessibility semantics, and user feedback.

Presentation depends on application behavior and contains no persistence, OCR, catalog, or domain rules.

### Application

Use cases, workflow coordination, background-job orchestration, and presentation-facing state.

Application coordinates domain objects and repository interfaces without depending on concrete storage or service implementations.

### Domain

Canonical entities, value objects, policies, and invariants.

The domain is pure Dart and depends on no Flutter, Riverpod, database, OCR, catalog, or platform framework.

### Data

Repositories and adapters for SQLite, files, OCR, camera, catalog access, and future services.

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
- ReadingCycles;
- ReadingSessions;
- ReadingJourney;
- Progression;
- Settings.

Modules communicate through application/domain interfaces, not each other's storage models.

## Local Data

Local data is the sole MVP source of truth.

- Drift/SQLite stores structured entities, relationships, processing state, and migrations.
- App-private file storage holds source images.
- Database records reference files by managed local identifiers or paths.
- Imported catalog metadata is cached as a local snapshot.

The app must reconcile incomplete writes and orphaned files. Schema changes require versioned, tested migrations. Corruption or migration failure must produce a recoverable state and must not silently reset user data.

Archiving preserves related history. Permanent deletion must be explicit, confirmed, and implemented as a defined cleanup workflow.

## Capture and OCR Pipeline

Capture is a durable workflow:

1. write the captured image to a temporary app-private location;
2. create the pending Bite and move the image to its managed location;
3. complete capture only when both image and Bite record are durable;
4. enqueue a persistent on-device OCR job;
5. expose `captured`, `processing`, `ready`, or `failed` state;
6. store editable text on success;
7. resume incomplete work or expose retry after restart;
8. clean up abandoned temporary files safely.

OCR runs outside the UI thread. Its failure must not remove the source image or block unrelated interaction.

## Reactive Data Flow

```text
SQLite/File/Service Adapters
          -> Repositories
          -> Application Use Cases
          -> Riverpod State
          -> UI
```

The UI observes local state. Network responses and OCR results update local data first; the UI reacts to those updates.

## External and Native Boundaries

Define replaceable interfaces for:

- camera capture;
- OCR;
- catalog discovery;
- file storage;
- IDs and clock;
- future cloud OCR and synchronization.

Catalog results must be validated and mapped before entering the domain. Provider IDs and provenance must be retained. Existing PersonalBooks must never require a live catalog lookup.

Native Android/iOS implementations must remain isolated behind Dart interfaces.

## Privacy and Security

- Store personal data and images only in app-private locations.
- Do not place OCR text, page images, or sensitive metadata in production logs.
- Do not include personal content in analytics or crash payloads.
- Validate image inputs, catalog responses, file references, and database boundaries.
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

Accounts, cloud backup, synchronization, cloud OCR, analytics, and remote crash reporting are not part of the MVP.

Future implementations must use optional adapters, preserve local ownership, obtain appropriate user consent, and avoid changing the core domain.
