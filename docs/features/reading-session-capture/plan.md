# Step 5 Documentation and Future Implementation Plan

**Status:** In progress — Step 5 prototype implemented; ship gate open
**Last updated:** 2026-08-18

## 1. Purpose

Step 5 introduces the smallest coherent reading-session and page-image Bite flow while protecting BookBite's local-first, reader-first contract.

This plan coordinates two separately owned feature specifications:

- `docs/features/reading-session/spec.md` owns session selection, start, active-session presentation, assignment, ending, and compact session Bite status.
- `docs/features/capture-bite/spec.md` owns page-image capture, durable media persistence, Bite creation, background OCR, retry, and recovery.

Both specifications must be approved before application code, dependencies, generated files, database schemas, or roadmap completion checkboxes are changed.

## 2. Product Decisions

The MVP slice has four user-facing pages or page states:

1. an idle Start a session page with local Library search;
2. a selected-book confirmation page;
3. an active-session page with promoted capture actions;
4. a full-screen camera page with an in-place photo review state.

Fixed decisions:

- Visual design is approximate and reuses the Sage and Paper system; pixel-perfect reproduction of the supplied HTML is not required.
- Opening a route or selecting a book performs no domain write.
- A reader may explicitly start without a book.
- Successful durable capture without an active session creates an unassigned session.
- Camera is functional; Voice remains visible but disabled until Step 6.
- Add a new book, camera switching, and Gallery are visible but disabled.
- FocusMode, page counters, progress percentages, Bite editing, and expanded Bite details are deferred.
- The active page shows only small Bite thumbnails with extraction status and a Retry action for failures.

## 3. Ownership and Shared Contracts

Reading Session owns:

- local PersonalBook selection and search;
- ReadingCycle selection or creation for an assigned start;
- the single-active-session rule;
- assigned and unassigned session presentation;
- assignment of an active unassigned session;
- the timer, compact session Bites, and End session.

Capture Bite owns:

- camera permission and temporary image lifecycle;
- capture and review;
- validation and managed source-media persistence;
- atomic creation of a page-image Bite and extraction job;
- creation or reuse of the active session during durable capture;
- OCR execution, status transitions, retry, and file/job reconciliation.

Shared invariants:

- At most one ReadingSession is active.
- Every new Bite is linked to the active or capture-created session.
- A Bite inherits its session's PersonalBook and ReadingCycle unless explicitly reassigned later.
- Cancel, permission denial, Retake, or failure before durable commit creates no Bite or session.
- Durable confirmation occurs only after the source image and required database records are safe.
- OCR is background work and never blocks navigation or another capture.
- Source media and extracted text never leave the device or enter logs.

## 4. Proposed Architecture

Use feature-first Clean Architecture:

- presentation: four pages/states, localized feedback, routing, semantics, and Riverpod state;
- application: start/end/assign workflows, durable capture coordination, extraction-job orchestration, and recovery;
- domain: pure-Dart ReadingCycle, ReadingSession, Bite, status values, policies, and repository contracts;
- data: Drift repositories, app-private file storage, camera adapter, Tesseract adapter, and persistent job runner.

The future schema migration adds ReadingCycle, ReadingSession, Bite, managed-media, and extraction-job storage. It must enforce the single-active-session invariant at the database boundary and preserve all existing version-3 data.

The file system and SQLite cannot share one physical transaction. The capture coordinator therefore persists managed media first, commits session/Bite/media/job records in one database transaction, and compensates or later reconciles an orphaned file if the database transaction fails.

## 5. Future Implementation Order

After both specifications are Approved:

1. Add pure-Dart entities, policies, repository interfaces, and unit tests.
2. Add the versioned Drift migration, constraints, repositories, and migration/failure tests.
3. Add managed-media validation and reconciliation.
4. Add application use cases and Riverpod controllers for session lifecycle and capture commit.
5. Add the camera adapter, four page states, the background OCR job runner, and the isolated Tesseract 5 adapter with bundled English/Persian trained data. Image-to-text OCR is part of Step 5; it starts after durable photo confirmation and does not block navigation.
6. Add Voice capture and speech-to-text. Voice remains visible but disabled until this step.
7. Complete the persistent Drift job/session/media migration, restart reconciliation, and durable OCR status/retry wiring around the Step 5 contracts.
8. Complete widget, integration, accessibility, restart-recovery, corpus, and physical-device verification.

## 6. Verification and Approval Gates

Approval requires:

- semantic consistency with the seven core specifications;
- explicit routes, states, recovery, assignment, and back behavior;
- measurable durability, OCR quality, and latency criteria;
- mapped unit, state, widget, repository, migration, adapter, integration, accessibility, and physical-device tests;
- both feature specifications under 700 lines;
- no unresolved blocking review finding.

Implementation completion later requires every acceptance criterion in both specifications, successful version-3 migration coverage, the approved OCR corpus thresholds, and data-preservation verification across cancellation, failure, and restart.

## 7. Step 5 Implementation Checklist

This checklist records the current repository state. A checked prototype item is not a release approval; the ship gate remains open until the unchecked durability and device-verification items are complete.

### Implemented in the current Step 5 slice

- [x] Idle, selected-book confirmation, active-session, and camera/review page states.
- [x] `/reading-session/capture/photo` route pushed above the reading-session context.
- [x] Camera adapter, Android camera permission, review, Retake, Use photo, and disabled Gallery/camera-switch controls.
- [x] Local Tesseract adapter with bundled English (`eng`) and Persian (`fas`) trained data.
- [x] Single-worker background OCR queue with queued, processing, ready, failed, duplicate protection, and retry.
- [x] Active-session Bite cards showing OCR status and extracted text after returning from capture.
- [x] Localized OCR status and recovery labels plus OCR runner unit coverage.

### Remaining before Step 5 is shippable

- [ ] Drift records for ReadingSession, Bite, managed media, and extraction jobs, including migration and constraints.
- [ ] Durable managed-image persistence, path/dimension validation, orphan reconciliation, and source retention.
- [ ] Capture-created unassigned sessions, active-session reuse, assignment inheritance, and restart restoration.
- [ ] Persisted OCR status/text, retry after process restart, and idempotent durable capture confirmation.
- [ ] Widget/integration/accessibility coverage for camera, review, OCR status, retry, RTL, large text, and process recovery.
- [ ] Physical-device Android camera/OCR verification, pinned model provenance, corpus CER results, and performance measurements.
- [ ] Successful debug/release APK build and real-device smoke test.

The Reading Session and Capture Bite acceptance checklists remain authoritative: the implemented items above support RS-06 and parts of RS-08/CB-02/CB-07/CB-08, but no RS/CB criterion is marked complete until its persistence, recovery, and verification requirements pass.

## 8. Cross-Specification Review Record

### Architecture

**Passes:** Ownership follows existing modules and dependency direction; capture-created sessions and assignment inheritance match the domain model.

**Risk addressed:** File/database atomicity is impossible; compensation plus startup reconciliation is specified instead of claiming a cross-resource transaction.

**Required before coding:** Pin concrete schema constraints and adapter contracts during implementation without moving orchestration into presentation.

### Security and privacy

**Passes:** Processing is local, media is app-private, permission is just in time, and personal content is excluded from diagnostics.

**Risk addressed:** Temporary, malformed, missing, and orphaned images have bounded validation and cleanup rules.

**Required before coding:** Record Tesseract asset provenance, checksums, and licenses; verify release logs and crash payloads contain no personal content.

### Quality

**Passes:** Acceptance criteria cover success, concurrency, denial, cancellation, rollback, restart, retry, migration, accessibility, and physical-device OCR.

**Risk addressed:** OCR thresholds use a fixed versioned corpus rather than anecdotal samples.

**Required before coding:** Approve the corpus and exact Pixel 6a OS/build record before treating benchmark results as release evidence.

### User advocacy

**Passes:** The reader returns after durable save while OCR continues and may take another photo immediately.

**Risk addressed:** Disabled future controls are explicitly styled and labeled as unavailable rather than appearing broken.

**Recommendation:** Revisit disabled Add, Voice, camera-switch, and Gallery controls when their owning features are scheduled.

### Governance

**Passes:** The split follows roadmap Step 5, preserves core terminology, and records deferred overall-MVP capabilities without deleting them from product scope.

**Blocking concerns:** None after the specifications incorporate the review changes.

**ADR:** Not required; the design applies the existing local-first capture architecture rather than introducing a new architectural tradeoff.
