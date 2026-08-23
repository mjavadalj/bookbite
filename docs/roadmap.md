# BookBite MVP Delivery Roadmap

**Last verified:** 2026-08-23

**Automated verification:** `flutter analyze` passes with no issues and all 52 automated tests pass serially. The debug Android APK was most recently verified on 2026-08-22 with the pinned AGP 8.11.1, Kotlin 2.2.20, and NDK 28.2.13676358 toolchain.

**Open release evidence:** approved-device OCR/Whisper accuracy, latency, memory, thermal, installed-size, TalkBack, dynamic-text, and RTL checks remain physical-device gates rather than unverified completion claims.

## Purpose

This is BookBite's living delivery roadmap. It records the planned implementation order for the current MVP and will be extended as later features are defined.

Every major capability must have an approved feature specification before implementation. Work must also comply with the product constitution, MVP scope, domain model, technical architecture, technical stack, navigation rules, design system, and approved feature designs in `docs/`.

## Status Legend

- [ ] Not started
- [x] Completed

## 1. Application Foundation

- [x] Bootstrap the Flutter application using the approved feature-first Clean Architecture structure.
- [x] Pin the Flutter and Dart SDK versions and enable strict analysis.
- [x] Implement the Sage and Paper MVP theme using shared semantic design tokens.
- [x] Configure English LTR and Persian RTL localization from the first feature.
- [x] Create the generated typed `go_router` navigation shell and restoration foundations.
- [x] Configure Riverpod 3 with code generation for dependency wiring and presentation state.
- [x] Configure Drift over SQLite with schema versioning and migration-test support.
- [x] Establish replaceable interfaces for catalog access, managed file storage, OCR, speech-to-text, clocks, and ID generation.
- [x] Add baseline CI checks for formatting, analysis, generated code, tests, and database migrations.
- [x] Show a recoverable in-app launch/loading state while environment and local first-run state initialize.
- [x] Add localized, responsive first-run onboarding with Skip, completion persistence, English LTR, Persian RTL, reduced-motion, and large-text support.
- [ ] Install the exact user-supplied launcher and launch-screen icon source files once they are available in the workspace; generated or redrawn substitutes are explicitly excluded.

### Completion Gate

- [x] The application launches into the approved navigation shell in English and Persian.
- [x] Architecture boundaries can be verified without concrete catalog, OCR, or speech framework types leaking into the domain.
- [x] The initial database can be created, reopened, and migrated through automated tests.

## 2. Discover and Active Search

- [x] Write and approve one Discover feature specification covering both browse mode and the dedicated active-search surface.
- [x] Define measurable performance, accessibility, localization, caching, restoration, and failure-state criteria in the specification.
- [x] Implement Open Library behind the replaceable catalog interface.
- [x] Identify BookBite in Open Library requests and follow the provider's validation, caching, and rate-limit guidance.
- [x] Map and validate provider responses before they enter the domain.
- [x] Implement the weekly shelf, trending `All` results grid, and category/Filter preview feedback from the approved design baseline.
- [x] Implement the dedicated active-search route with Cancel, debounced queries, preserved results during refresh, and restored query state after Back navigation.
- [x] Preserve query, loaded results, rail position, and scroll position when returning from child routes.
- [x] Cache a bounded set of browse and search summaries.
- [x] Search locally cached catalog records when the device is offline and cached data is available.
- [x] Expose the manual PersonalBook creation entry point when offline, when the provider is unavailable, or when no result matches.
- [x] Implement populated, loading, refreshing, empty, no-results, offline, catalog-unavailable, recoverable-error, malformed-response, and missing-cover states.

### Completion Gate

- [x] Browse and search remain responsive and restore their prior state after navigation and application restoration.
- [x] Offline search clearly identifies locally cached results and never presents them as newly fetched data.
- [x] Open Library failure does not affect local data or other application destinations.
- [ ] Discover and Active Search pass their unit, state, widget, accessibility, RTL, and adapter-contract tests.

## 3. CatalogBook Detail

- [x] Write and approve a separate CatalogBook Detail feature specification.
- [x] Implement the approved cover-led detail screen and collapsing header behavior.
- [x] Display available cover, title, authors, description, publication date, edition, language, page count, identifiers, subjects or categories, and related books.
- [x] Handle absent or inconsistent provider fields without inventing metadata.
- [x] Fetch and cache full CatalogBook metadata when a detail page is opened.
- [x] Keep the five most recently opened full-detail records using least-recently-used eviction.
- [x] Update recency whenever a cached CatalogBook detail is opened.
- [x] Serve CatalogBook Detail offline when its full record is cached.
- [x] Show a recoverable unavailable state when the requested detail is neither reachable nor cached.
- [x] Keep disposable CatalogBook detail records separate from permanent PersonalBook metadata snapshots.
- [x] Ensure imported PersonalBook metadata is never deleted by catalog-cache eviction.
- [x] Restore the originating Discover or Active Search state when navigating back.

### Completion Gate

- [x] The full-detail cache never retains more than five disposable detail records.
- [x] LRU eviction and offline detail behavior pass repository and integration tests.
- [ ] Missing fields, missing covers, malformed responses, provider failure, restart, reduced motion, dynamic text, and RTL are verified.
## 4. Add to Personal Library

- [x] Finalize catalog import and manual PersonalBook creation behavior.
- [x] Add versioned Drift schemas for PersonalBook records and optional catalog provenance.
- [x] Store imported catalog metadata as a permanent local snapshot owned by the PersonalBook.
- [x] Implement PersonalBook domain and repository interfaces without coupling them to Open Library.
- [x] Import a CatalogBook transactionally using a stable local PersonalBook ID.
- [x] Make imports idempotent by provider and provider-specific edition ID.
- [x] Return the existing PersonalBook when the same provider edition has already been imported.
- [x] Allow a different edition or translation to become a separate PersonalBook.
- [x] Implement manual PersonalBook creation with a required title and no catalog dependency.
- [x] Keep the user on CatalogBook Detail after a successful import and show a confirmed saved state.
- [x] Make repeated Add actions safe and prevent duplicate records.
- [x] Implement the offline Library page and core PersonalBook Detail page.
- [x] Implement the approved PersonalBook reading-journey presentation with persisted session metrics, a trend summary, and session history.
- [x] Add a dedicated PersonalBook Bite collection with word search, predefined-tag filters, and per-Bite text/tag editing.

### Completion Gate

- [x] Imported PersonalBooks remain available after restart and without network access.
- [x] Import rollback prevents partial PersonalBook records after database or mapping failure.
- [x] Duplicate import, separate-edition import, migration, and catalog-cache eviction scenarios are tested.

## 5. Reading Session, Bite, and OCR

**Current status:** Durable local capture, session/Bite/media/job persistence, editable tagged Bite text, restart recovery, and the redesigned active-session presentation are implemented. Physical OCR quality/performance evidence and full reconciliation/deletion verification remain open.

- [x] Add the idle, selected-book confirmation, active-session, and camera/review page states.
- [x] Add the typed `/reading-session/capture/photo` route above the reading-session context.
- [x] Add the camera adapter, Android camera permission, review, Retake, Use photo, and disabled Gallery/camera-switch controls.

- [x] Write and approve the Reading Session feature specification.
- [x] Write and approve the page-image Bite and OCR feature specification, including measurable English and Persian quality targets and a test corpus.
- [x] Add versioned Drift schemas for ReadingCycle, ReadingSession, Bite, managed source-media references, and persistent extraction jobs.
- [x] Implement domain and repository boundaries for sessions, cycles, Bites, media, and extraction jobs.
- [x] Enforce at most one active ReadingSession.
- [x] Ensure opening the Reading Session destination performs no domain write.
- [x] Support explicit session start and automatic session creation after the first successful durable capture when no session is active.
- [x] Reuse the active session for subsequent captures.
- [x] Allow ReadingSession, Bite, PersonalBook, and ReadingCycle assignments to remain absent and be added later.
- [x] Link every newly captured Bite to the active or newly created ReadingSession.
- [x] Make a session-linked Bite inherit the session's PersonalBook and ReadingCycle assignment unless explicitly reassigned or detached.
- [x] Save valid page images in app-private managed storage before confirming capture.
- [x] Commit the session, Bite, and managed media reference as one durable workflow.
- [x] Create neither a Bite nor a ReadingSession when capture is canceled or fails before durability.
- [x] Integrate Tesseract 5 behind the OCR interface with bundled English and Persian models.
- [x] Run OCR asynchronously through a single-worker prototype job queue without blocking navigation.
- [x] Expose queued, processing, ready, and recoverable failed states in the active Reading Session Bite cards, including extracted text and Retry.
- [x] Run OCR outside the UI thread through persistent extraction jobs.
- [x] Persist `captured`, `processing`, `ready`, and recoverable `failed` states.
- [x] Store editable extracted text while retaining source media until the user deletes it.
- [x] Persist zero or more predefined Bite tags: Quotes, Thoughts, Ideas, Questions, and Lessons.
- [x] Allow Bite text and tags to be edited together from book and session Bite cards.
- [x] Add a dedicated session Bite collection with word search, tag filters, and a visible edit action on every Bite.
- [x] Redesign the active Reading Session with a live timer, capture actions, the two newest Bites, and a `See all` route beside the session Bite count.
- [x] Resume interrupted extraction after restart or move it to a recoverable failed state.
- [x] Reconcile temporary files, incomplete writes, and orphaned managed media safely.

### Completion Gate

The following prototype checks are complete, but they do not satisfy the durable completion gate below:

- [x] A captured image can return to an active session and display OCR status and extracted text.
- [x] OCR runner unit coverage covers success, duplicate enqueue protection, and recoverable failure.
- [x] A file-backed close/reopen test preserves the PersonalBook, completed ReadingSession, Bite text, and multiple Bite tags.
- [x] Widget coverage verifies Bite word search and persisted-tag filtering.

- [x] Durable capture confirms only after media and records are safe.
- [x] OCR failure or application restart never deletes the Bite or its source image.
- [ ] Session creation, active-session reuse, assignment inheritance, cancellation, rollback, retry, restart recovery, media deletion, and migration behavior are covered by tests.
- [ ] English and Persian OCR meet the approved quality and performance thresholds on the approved reference device.

## 6. Voice-to-Text

- [x] Write and approve the voice-Bite specification with measurable English and Persian accuracy, latency, package-size, and memory criteria.
- [x] Reuse the existing durable Bite, ReadingSession, assignment, media, and processing-job pipeline.
- [x] Record app-private 16 kHz mono PCM WAV audio through the replaceable recording interface.
- [x] Provide Stop and Cancel actions and stop recording automatically at 5 seconds.
- [x] Create no Bite or ReadingSession after permission denial, cancellation, or failure before durable audio capture.
- [x] Integrate `whisper.cpp` behind the replaceable speech-to-text interface.
- [ ] Benchmark candidate quantized multilingual Whisper models on the approved minimum device.
- [ ] Obtain approval and pin the bundled model only after it meets the defined quality, package-size, memory, and latency thresholds.
- [x] Run transcription outside the UI thread after recording stops.
- [x] Expose durable capture confirmation, processing state, editable results, recoverable failure, and retry.
- [x] Resume interrupted transcription after restart or move it to a recoverable failed state.
- [x] Retain voice recordings until explicitly deleted and preserve editable text after source deletion.

### Completion Gate

- [ ] Voice capture and transcription work fully on-device in English and Persian.
- [x] Permission denial leaves Photo capture, PersonalBooks, and all existing data usable.
- [ ] Automatic stop, manual stop, cancellation, permission denial, restart recovery, retry, source deletion, assignment inheritance, and active-session reuse are covered by tests.

## 7. Library Presentation, ReadingJourney, and Basic Progression

**Current status:** The approved minimum Library and Journey presentations are implemented from local persisted data. Progression is deliberately limited to accumulated ReadingSession time and contains no competitive or reward mechanics.

- [x] Write and approve Library presentation and ReadingJourney/basic-progression feature specifications.
- [x] Implement the warm, vertically scrollable Library hierarchy from the approved reference.
- [x] Present persisted PersonalBooks as a horizontally scrollable, accessible bookshelf without inventing cover art or metadata.
- [x] Derive Library reading progress, book count, streak, and level from local records.
- [x] Implement the private Journey reader header without adding an account or public Profile destination.
- [x] Derive total time, today's time, completed sessions, streak, and level from persisted ReadingSessions.
- [x] Implement a 16-week Monday-to-Sunday contribution heatmap with per-cell date/minute semantics.
- [x] Split sessions that cross midnight across their actual local calendar days.
- [x] Count active-session time only through the current time.
- [x] Implement calm hourly progression: Level 1 initially, then one level per 60 accumulated minutes.
- [x] Implement the PersonalBook Detail journey surface using the book's persisted sessions and Bites.
- [x] Provide typed navigation from PersonalBook Detail to the searchable, tag-filterable book Bite collection.
- [ ] Localize the new PersonalBook Detail, Bite collection, tag-editor, and redesigned active-session strings in English and Persian.

### Completion Gate

- [x] OCR and voice-transcription text are editable and persist after Save in both active-session and PersonalBook contexts.
- [x] Library and Journey render from persisted local records and perform no read-side domain writes.
- [x] Duration aggregation, active-session calculation, midnight distribution, streak, and level progression have deterministic unit coverage.
- [x] Populated Library, Journey heatmap, Photo/Voice editing, 375px phone, Persian RTL at 200% text, and phone-landscape layouts have widget coverage.
- [x] Database close/reopen coverage verifies that books, sessions, Bite edits, tags, and Journey inputs remain durable.
- [ ] TalkBack traversal and physical-device visual review remain release evidence gates.

## Cross-Cutting Verification

Every milestone must verify, as applicable:

- [ ] Positive and primary user flows.
- [ ] Initial, populated, empty, loading, and background-processing states.
- [ ] Offline, unavailable external-service, malformed-data, timeout, and recoverable-error behavior.
- [ ] Restart, restoration, interrupted-write, migration, and data-preservation behavior.
- [ ] English LTR and Persian RTL layouts, localization, and mixed-direction content.
- [ ] Screen-reader semantics, focus order, accessible contrast, 48dp touch targets, dynamic text, and reduced motion.
- [ ] Measurable interaction, rendering, OCR, and speech performance criteria from the relevant feature specification.
- [ ] Unit, Riverpod application-state, widget, Drift repository and migration, adapter-contract, selective golden, and end-to-end tests appropriate to the work.
- [ ] Privacy-safe diagnostics that exclude extracted text, source media, and sensitive personal metadata.
- [ ] Catalog outages and cache cleanup cannot modify or block PersonalBooks, ReadingSessions, Bites, or retained media.

## Deferred Work

The following work is intentionally outside the milestones currently defined in this roadmap:

- PersonalBook metadata editing, archiving, and deletion.
- Accounts, synchronization, cloud backup, and cloud text extraction.
- Personalized recommendations, reviews, ratings, and social features.
- Remaining MVP and post-MVP capabilities not yet specified.

## Roadmap Assumptions

- Discover browse and Active Search share one feature specification and delivery milestone.
- CatalogBook Detail is a separate feature specification and milestone.
- The five-book limit applies only to disposable full CatalogBook detail cache entries.
- Browse and search summaries use a separately bounded cache whose exact limits are defined by the Discover specification.
- Imported PersonalBook metadata is a permanent local snapshot and is never subject to catalog-cache eviction.
- Adding a CatalogBook keeps the user on CatalogBook Detail and shows a confirmed saved state; the saved PersonalBook is available from Library and PersonalBook Detail.
- Local data remains the sole MVP source of truth; the network is used only for external catalog discovery.
- This document will be updated as milestones are completed or later work is approved.
