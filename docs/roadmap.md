# BookBite MVP Delivery Roadmap

**Last verified:** 2026-08-08

## Purpose

This is BookBite's living delivery roadmap. It records the planned implementation order for the current MVP and will be extended as later features are defined.

Every major capability must have an approved feature specification before implementation. Work must also comply with the product constitution, MVP scope, domain model, technical architecture, technical stack, navigation rules, design system, and approved feature designs in `docs/`.

## Status Legend

- [ ] Not started
- [x] Completed

## 1. Application Foundation

- [x] Bootstrap the Flutter application using the approved feature-first Clean Architecture structure.
- [x] Pin the Flutter and Dart SDK versions and enable strict analysis.
- [ ] Implement the Sage and Paper MVP theme using shared semantic design tokens.
- [x] Configure English LTR and Persian RTL localization from the first feature.
- [ ] Create the generated typed `go_router` navigation shell and restoration foundations.
- [ ] Configure Riverpod 3 with code generation for dependency wiring and presentation state.
- [ ] Configure Drift over SQLite with schema versioning and migration-test support.
- [x] Establish replaceable interfaces for catalog access, managed file storage, OCR, speech-to-text, clocks, and ID generation.
- [ ] Add baseline CI checks for formatting, analysis, generated code, tests, and database migrations.

### Completion Gate

- [ ] The application launches into the approved navigation shell in English and Persian.
- [ ] Architecture boundaries can be verified without concrete catalog, OCR, or speech framework types leaking into the domain.
- [ ] The initial database can be created, reopened, and migrated through automated tests.

## 2. Discover and Active Search

- [x] Write and approve one Discover feature specification covering both browse mode and the dedicated active-search surface.
- [x] Define measurable performance, accessibility, localization, caching, restoration, and failure-state criteria in the specification.
- [x] Implement Open Library behind the replaceable catalog interface.
- [x] Identify BookBite in Open Library requests and follow the provider's validation, caching, and rate-limit guidance.
- [x] Map and validate provider responses before they enter the domain.
- [x] Implement the weekly shelf, trending `All` results grid, and category/Filter preview feedback from the approved design baseline.
- [x] Implement the dedicated active-search route with Cancel, debounced queries, preserved results during refresh, and restored query state after Back navigation.
- [ ] Preserve query, loaded results, rail position, and scroll position when returning from child routes.
- [ ] Cache a bounded set of browse and search summaries.
- [ ] Search locally cached catalog records when the device is offline and cached data is available.
- [x] Expose the manual PersonalBook creation entry point when offline, when the provider is unavailable, or when no result matches.
- [x] Implement populated, loading, refreshing, empty, no-results, offline, catalog-unavailable, recoverable-error, malformed-response, and missing-cover states.

### Completion Gate

- [ ] Browse and search remain responsive and restore their prior state after navigation and application restoration.
- [ ] Offline search clearly identifies locally cached results and never presents them as newly fetched data.
- [ ] Open Library failure does not affect local data or other application destinations.
- [ ] Discover and Active Search pass their unit, state, widget, accessibility, RTL, and adapter-contract tests.

## 3. CatalogBook Detail

- [ ] Write and approve a separate CatalogBook Detail feature specification.
- [ ] Implement the approved cover-led detail screen and collapsing header behavior.
- [ ] Display available cover, title, authors, description, publication date, edition, language, page count, identifiers, subjects or categories, and related books.
- [ ] Handle absent or inconsistent provider fields without inventing metadata.
- [ ] Fetch and cache full CatalogBook metadata when a detail page is opened.
- [ ] Keep the five most recently opened full-detail records using least-recently-used eviction.
- [ ] Update recency whenever a cached CatalogBook detail is opened.
- [ ] Serve CatalogBook Detail offline when its full record is cached.
- [ ] Show a recoverable unavailable state when the requested detail is neither reachable nor cached.
- [ ] Keep disposable CatalogBook detail records separate from permanent PersonalBook metadata snapshots.
- [ ] Ensure imported PersonalBook metadata is never deleted by catalog-cache eviction.
- [ ] Restore the originating Discover or Active Search state when navigating back.

### Completion Gate

- [ ] The full-detail cache never retains more than five disposable detail records.
- [ ] LRU eviction and offline detail behavior pass repository and integration tests.
- [ ] Missing fields, missing covers, malformed responses, provider failure, restart, reduced motion, dynamic text, and RTL are verified.

## 4. Add to Personal Library

- [ ] Finalize and approve the import and manual PersonalBook creation behavior in the relevant feature specification.
- [ ] Add versioned Drift schemas for PersonalBook records and optional catalog provenance.
- [ ] Store imported catalog metadata as a permanent local snapshot owned by the PersonalBook.
- [ ] Implement PersonalBook domain and repository interfaces without coupling them to Open Library.
- [ ] Import a CatalogBook transactionally using a stable local PersonalBook ID.
- [ ] Make imports idempotent by provider and provider-specific edition ID.
- [ ] Return the existing PersonalBook when the same provider edition has already been imported.
- [ ] Allow a different edition or translation to become a separate PersonalBook.
- [ ] Implement manual PersonalBook creation with a required title and no catalog dependency.
- [ ] Keep the user on CatalogBook Detail after a successful import and show a confirmed saved state.
- [ ] Make repeated Add actions safe and prevent duplicate records.
- [ ] Defer the Library page and PersonalBook Detail page.

### Completion Gate

- [ ] Imported and manually created PersonalBooks remain available after restart and without network access.
- [ ] Import rollback prevents partial PersonalBook records after database or mapping failure.
- [ ] Duplicate import, separate-edition import, offline creation, migration, and catalog-cache eviction scenarios are tested.

## 5. Reading Session, Bite, and OCR

- [ ] Write and approve the Reading Session feature specification.
- [ ] Write and approve the page-image Bite and OCR feature specification, including measurable English and Persian quality targets and a test corpus.
- [ ] Add versioned Drift schemas for ReadingCycle, ReadingSession, Bite, managed source-media references, and persistent extraction jobs.
- [ ] Implement domain and repository boundaries for sessions, cycles, Bites, media, and extraction jobs.
- [ ] Enforce at most one active ReadingSession.
- [ ] Ensure opening the Reading Session destination performs no domain write.
- [ ] Support explicit session start and automatic session creation after the first successful durable capture when no session is active.
- [ ] Reuse the active session for subsequent captures.
- [ ] Allow ReadingSession, Bite, PersonalBook, and ReadingCycle assignments to remain absent and be added later.
- [ ] Link every newly captured Bite to the active or newly created ReadingSession.
- [ ] Make a session-linked Bite inherit the session's PersonalBook and ReadingCycle assignment unless explicitly reassigned or detached.
- [ ] Save valid page images in app-private managed storage before confirming capture.
- [ ] Commit the session, Bite, and managed media reference as one durable workflow.
- [ ] Create neither a Bite nor a ReadingSession when capture is canceled or fails before durability.
- [ ] Integrate Tesseract 5 behind the OCR interface with bundled English and Persian models.
- [ ] Run OCR outside the UI thread through persistent extraction jobs.
- [ ] Expose `captured`, `processing`, `ready`, and recoverable `failed` states.
- [ ] Store editable extracted text while retaining source media until the user deletes it.
- [ ] Resume interrupted extraction after restart or move it to a recoverable failed state.
- [ ] Reconcile temporary files, incomplete writes, and orphaned managed media safely.

### Completion Gate

- [ ] Durable capture confirms only after media and records are safe.
- [ ] OCR failure or application restart never deletes the Bite or its source image.
- [ ] Session creation, active-session reuse, assignment inheritance, cancellation, rollback, retry, restart recovery, media deletion, and migration behavior are covered by tests.
- [ ] English and Persian OCR meet the approved quality and performance thresholds on the approved reference device.

## 6. Voice-to-Text

- [ ] Write and approve the voice-Bite specification with measurable English and Persian accuracy, latency, package-size, and memory criteria.
- [ ] Reuse the existing durable Bite, ReadingSession, assignment, media, and processing-job pipeline.
- [ ] Record app-private 16 kHz mono PCM WAV audio through the replaceable recording interface.
- [ ] Provide Stop and Cancel actions and stop recording automatically at 30 seconds.
- [ ] Create no Bite or ReadingSession after permission denial, cancellation, or failure before durable audio capture.
- [ ] Integrate `whisper.cpp` behind the replaceable speech-to-text interface.
- [ ] Benchmark candidate quantized multilingual Whisper models on the approved minimum device.
- [ ] Obtain approval and pin the bundled model only after it meets the defined quality, package-size, memory, and latency thresholds.
- [ ] Run transcription outside the UI thread after recording stops.
- [ ] Expose durable capture confirmation, processing state, editable results, recoverable failure, and retry.
- [ ] Resume interrupted transcription after restart or move it to a recoverable failed state.
- [ ] Retain voice recordings until explicitly deleted and preserve editable text after source deletion.

### Completion Gate

- [ ] Voice capture and transcription work fully on-device in English and Persian.
- [ ] Permission denial leaves Photo capture, PersonalBooks, and all existing data usable.
- [ ] Automatic stop, manual stop, cancellation, permission denial, restart recovery, retry, source deletion, assignment inheritance, and active-session reuse are covered by tests.

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

- Library page implementation.
- PersonalBook Detail page implementation.
- ReadingJourney and progression UI.
- Accounts, synchronization, cloud backup, and cloud text extraction.
- Personalized recommendations, reviews, ratings, and social features.
- Remaining MVP and post-MVP capabilities not yet specified.

## Roadmap Assumptions

- Discover browse and Active Search share one feature specification and delivery milestone.
- CatalogBook Detail is a separate feature specification and milestone.
- The five-book limit applies only to disposable full CatalogBook detail cache entries.
- Browse and search summaries use a separately bounded cache whose exact limits are defined by the Discover specification.
- Imported PersonalBook metadata is a permanent local snapshot and is never subject to catalog-cache eviction.
- Adding a CatalogBook keeps the user on CatalogBook Detail and shows a confirmed saved state until PersonalBook Detail is implemented.
- Local data remains the sole MVP source of truth; the network is used only for external catalog discovery.
- This document will be updated as milestones are completed or later work is approved.
