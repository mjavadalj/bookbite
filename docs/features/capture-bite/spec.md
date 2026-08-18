# Feature Specification: Capture Bite — Page Image and OCR

**Status:** Proposed
**Last updated:** 2026-08-18

## 1. Purpose

Capture Bite lets a reader photograph a meaningful printed page, confirm that the image is durably safe, return to reading immediately, and receive locally extracted English or Persian text in the background.

This specification owns page-image Bites only. Voice capture remains owned by Step 6.

## 2. Scope

### In scope

- full-screen camera and printed-page framing guide;
- just-in-time camera permission;
- shutter, in-place Review, Retake, Use photo, Cancel, and Back;
- visible disabled camera-switch and Gallery controls;
- image validation and app-private managed storage;
- active-session reuse or unassigned session creation;
- atomic Bite, media-reference, and extraction-job persistence;
- background Tesseract 5 OCR for printed English and Persian;
- persistent status, restart recovery, compact failed-state Retry;
- source retention, cleanup, and reconciliation;
- offline, privacy, accessibility, quality, and performance verification.

### Out of scope

- Voice capture and speech-to-text;
- functional camera switching or Gallery import;
- automatic crop, dewarp, blur scoring, or enhancement controls;
- handwriting, marginalia, tables, mathematical notation, and decorative layouts as quality targets;
- Bite text editing, expanded Bite detail, assignment UI, deletion UI, or manual OCR correction;
- cloud OCR, upload, analytics, accounts, or synchronization.

OCR text is stored in a mutable field for a later editor. Deferring that editor does not remove the overall MVP requirement to edit Bite text.

## 3. Fixed Decisions

1. Capture works fully offline from first launch.
2. Android 8/API 26 is the minimum supported Android version for this feature.
3. The official Flutter camera package is isolated behind an application-facing interface.
4. Tesseract 5 and bundled `eng` and `fas` trained data are isolated behind the OCR interface.
5. Camera-switch and Gallery controls are visibly disabled with localized semantics.
6. Shutter enters Review; OCR starts only after Use photo succeeds durably.
7. OCR never blocks the UI, navigation, or another capture.
8. Source images remain until an explicit later deletion operation.
9. OCR failure never deletes the Bite or source image.

## 4. Route and Context

`/reading-session/capture/photo` is a full-screen child route above its origin. The route may also be invoked by other eligible destinations through the global Photo action.

The origin supplies navigation context only. Capture assignment is determined by the active ReadingSession at durable commit:

- if one exists, reuse it and inherit its assignment;
- otherwise create an unassigned session using the shutter/capture start time and link the Bite to it.

Cancel or Back before durable commit restores the origin and creates no domain record. After durable commit, return to the active Reading Session page while OCR continues. A later global-capture integration may restore another eligible origin, but it must preserve the same durable contract.

## 5. Camera and Review Experience

### Camera state

Show:

- live preview respecting safe areas and camera aspect ratio;
- a high-contrast page-shaped framing guide that does not imply automatic cropping;
- short localized guidance to align one printed page;
- shutter as the primary action;
- Cancel or Back;
- disabled switch-camera and Gallery controls with clear unavailable semantics.

The frame, instructions, and shutter remain understandable without relying on color. Controls use at least 48dp targets and do not conflict with system gestures.

### Review state

After shutter:

- freeze/show the captured image in the same route;
- preserve its natural aspect ratio and orientation;
- show Retake and Use photo;
- remove or disable the live shutter;
- treat Back like Cancel for this unsaved temporary image.

Retake deletes the temporary image, returns to the live preview, and creates no record. Use photo disables duplicate activation and shows immediate progress until durable commit succeeds or fails.

No auto quality gate blocks the reader. Invalid or unreadable files are rejected only for structural safety, with a concise recovery to Retake.

## 6. Permission and Camera Failures

Request camera permission only when opening Photo capture.

| Condition | Required behavior |
|---|---|
| First request | Explain the need in localized system/app context |
| Denied, requestable | Keep data and other app functions available; offer Try again and Cancel |
| Permanently denied | Explain how to open system settings; offer Cancel |
| No usable camera | Show unavailable state and Back; create nothing |
| Initialization interrupted | Release resources and restore or safely restart capture |
| Shutter failure | Keep route recoverable; create nothing; offer Retry |

Permission state, denial, and settings navigation must not start a session or create a Bite.

## 7. Durable Capture Contract

Use photo performs this workflow:

1. Validate that the temporary path is inside the owned temporary area, is a regular readable file, has a supported encoded image type, has nonzero bounded size, and decodes within configured dimension limits.
2. Normalize encoded orientation without changing the photographed content.
3. Generate stable local media, Bite, job, and—only if needed—session IDs before database work.
4. Persist the validated image to its final app-private managed location using a same-volume atomic rename where available, otherwise a write-flush-verify-rename sequence.
5. In one Drift transaction:
   - re-read the active session;
   - reuse it or create one unassigned session at capture start;
   - create one `pageImage` Bite with `captured` status;
   - apply inherited session/PersonalBook/ReadingCycle assignment;
   - create the managed-media reference;
   - create one queued OCR job.
6. Confirm capture and return only after the file and transaction are durable.
7. Wake the background OCR runner independently of navigation.

If the transaction fails, attempt to remove the newly managed file. If cleanup fails or the process stops, startup reconciliation identifies the file as an orphan. Never claim a cross-file-system/database transaction.

Duplicate Use photo activation and workflow retry use stable operation identity and must not create duplicate sessions, Bites, media, or jobs.

## 8. Domain and Persistence Contract

### Required records

- ReadingCycle when an assigned start created one; Capture Bite does not otherwise invent a cycle.
- ReadingSession with optional PersonalBook/ReadingCycle assignment.
- Bite with `pageImage`, managed source reference, optional extracted text, assignment, timestamps, and extraction status.
- Managed media with stable ID/reference, kind, byte size, integrity metadata sufficient for reconciliation, and timestamps.
- Extraction job with stable ID, Bite ID, queued/running/failed lifecycle, attempt count, safe error code, and timestamps.

Schema rules must enforce:

- valid foreign keys and one media record per page-image Bite;
- one extraction job identity per Bite/processing generation;
- at most one active ReadingSession through a database constraint/index;
- allowed status/source values;
- assignment consistency when a session derives its PersonalBook from a ReadingCycle.

Concrete Drift rows and native OCR/camera types remain in data adapters. Domain and application contracts use pure Dart values and managed IDs.

### Required interfaces

- camera service: initialize, capture to owned temporary media, dispose;
- managed storage: persist, inspect/verify, delete, and enumerate owned temporary/managed candidates for reconciliation;
- durable capture repository/coordinator: commit the file-backed Bite workflow idempotently;
- extraction job repository: enqueue, claim, complete, fail, requeue, and observe;
- OCR service: extract printed text from a managed image using approved language configuration.

Exact names may follow project conventions. Responsibilities and dependency boundaries are fixed.

## 9. OCR Processing

The persistent runner:

1. atomically claims the next queued job;
2. sets the Bite to `processing`;
3. verifies that managed source media exists and is readable;
4. runs OCR outside the UI isolate/thread using bundled `eng` and `fas` data;
5. writes extracted Unicode text and `ready` atomically on success;
6. writes a safe recoverable error and `failed` on terminal failure;
7. never deletes the source or Bite because extraction failed.

Run one OCR job at a time for the MVP to bound CPU and memory. Additional captures remain durable and queued. The user can navigate and take another photo while processing continues.

On restart:

- queued jobs remain queued;
- a stale running job is safely requeued once or moved to `failed` after the bounded attempt policy;
- completion is idempotent;
- missing/corrupt source enters `failed` with an explanation that the Bite record remains;
- Retry reuses the Bite and media, clears only safe error state, and queues a new processing attempt.

Attempt limits and backoff must be deterministic and tested. Automatic retries must be bounded; user Retry remains available for recoverable failure.

## 10. Reconciliation and Retention

At startup and after interrupted workflows:

- remove expired owned temporary captures that have no durable record;
- detect managed files with no media record and delete them only after a grace period and second verification;
- detect media records whose files are missing and mark their Bite recoverably failed without deleting text;
- detect invalid job/Bite combinations and repair to a safe queued or failed state;
- never scan, modify, or delete outside app-owned directories;
- never silently reset the database after corruption or migration failure.

Source image deletion is a repository capability for a later confirmed UI. It removes only the managed source/media reference and preserves the Bite and extracted text. Its behavior must be tested now because it defines ownership and cleanup boundaries.

## 11. OCR Models and Reference Corpus

Before implementation approval becomes completion evidence, record:

- exact Tesseract engine/integration version;
- exact English and Persian trained-data versions and source;
- asset checksums, licenses, compressed/install sizes, and initialization behavior;
- physical reference-device model, RAM, Android version, thermal state, and release-build identifier.

Reference device: physical Google Pixel 6a-class hardware; the benchmark record must name the exact device. Android 8/API 26 compatibility is verified separately on a physical device or representative hardware-backed test device.

Corpus version 1 contains 100 photographed, printed public-domain pages:

- 60 English and 40 Persian pages;
- at least 10 source works per language;
- representative serif and sans-serif typefaces at 9-14pt;
- single-column prose with ordinary headings and paragraph breaks;
- ordinary indoor warm/cool light, mild perspective, rotation, and page curvature;
- matching NFC-normalized Unicode ground truth and a manifest of conditions.

Exclude handwriting, marginalia, tables, equations, severe blur/glare, multi-page spreads, and decorative layouts from the release threshold. Keep excluded challenge samples in a separate non-gating set.

Character error rate is Levenshtein edit distance divided by ground-truth character count after the documented normalization of line endings, Unicode normalization, and non-semantic repeated whitespace. Do not remove punctuation or alter Persian/Arabic characters merely to improve scores.

## 12. Quality and Performance Gates

On the approved physical Pixel 6a-class reference device in a release/profile-equivalent build:

- English median character error rate is at most 5%;
- Persian median character error rate is at most 15%;
- OCR completion is below 8 seconds p95 from job claim to persisted result;
- durable confirmation is below 2 seconds p95 from Use photo to safe records, excluding OCR;
- Camera/Review input feedback begins within 100ms;
- capture and session UI remain responsive while OCR runs;
- another photo can be reviewed and durably committed while earlier OCR is processing;
- peak memory, installed model size, and thermal observations are recorded even though this specification sets no separate numeric gate for them.

Measure OCR accuracy per page and report median plus p95 CER so poor pages are visible even though median is the release gate. A failed gate blocks completion and requires model/preprocessing/spec review; it must not be hidden by automatic text correction.

## 13. Privacy, Security, and Diagnostics

- Store temporary and managed images only in app-private locations excluded from media galleries.
- Validate canonical paths against owned roots; never trust arbitrary route, plugin, or database paths.
- Bound file size, dimensions, decoding work, and job retries to resist malformed input and resource exhaustion.
- Remove unnecessary image metadata during normalization when this does not compromise the retained source.
- Do not upload media or extracted text.
- Exclude images, extracted text, titles, paths, IDs linkable to content, and raw native errors from production logs/crash payloads.
- Persist only categorized safe error codes for user recovery and diagnostics.
- Record and comply with camera, OCR integration, and trained-data licenses.

## 14. Accessibility and Localization

- Localize all visible, semantic, permission, failure, and status text in English and Persian.
- Mirror directional controls appropriately in RTL; do not mirror captured page content.
- Give the framing guide a concise semantic description without forcing continuous preview announcements.
- Label shutter, Cancel, Retake, Use photo, settings, and disabled controls with role/state/hint.
- Ensure at least 48dp targets, 8dp spacing, safe-area clearance, visible focus/press states, and sufficient contrast.
- Support large text by allowing guidance/actions to reflow without obscuring the preview or system navigation.
- Use no essential capture instruction based only on color, animation, or frame orientation.
- Reduced motion removes nonessential transitions between Camera and Review.

## 15. Acceptance Criteria

### CB-01 — Permission boundaries

Permission is requested just in time; denial, permanent denial, missing camera, and settings return create no session or Bite.

### CB-02 — Camera and Review

The camera provides the frame and required controls; Retake and pre-commit Back/Cancel remove temporary media and create no records.

### CB-03 — Durable commit

Use photo confirms only after managed media plus one Bite/job and the reused or newly created session are durable.

### CB-04 — Active-session reuse

Capture reuses an active assigned/unassigned session, inherits compatible assignment, and never creates a second active session.

### CB-05 — Automatic unassigned session

Without an active session, successful durable capture creates exactly one unassigned session at capture start and links the Bite.

### CB-06 — Cancellation and rollback

Every denial, cancellation, validation failure, file failure, database failure, and duplicate activation preserves existing data and leaves no permanent duplicate or unhandled orphan.

### CB-07 — Non-blocking queue

After durable confirmation the reader returns, OCR runs in the background, and further captures can commit while jobs queue sequentially.

### CB-08 — Status and retry

Persisted `captured`, `processing`, `ready`, and `failed` changes react in UI; Retry is idempotent and retains source/Bite data.

### CB-09 — Restart recovery

Restart before commit creates nothing durable; restart after commit preserves the Bite; restart during OCR resumes or exposes recoverable failure.

### CB-10 — Media retention and reconciliation

Source survives OCR outcomes; temporary/orphan/missing-file cases follow section 10; source deletion preserves text.

### CB-11 — OCR gate

Pinned models and the versioned corpus meet every section 12 release gate with reproducible reports.

### CB-12 — Inclusive and private operation

Offline English/Persian, accessibility, path/media validation, app-private storage, and privacy-safe diagnostics meet sections 13-14.

## 16. Verification and Completion Gate

Test:

- pure-Dart Bite/status/assignment policies and safe error mapping;
- capture coordinator idempotency and every failure boundary with fake file/database services;
- Drift v3 migration, constraints, transaction rollback, active-session races, job claim, and source deletion;
- managed-storage path validation, flush/rename failure, cleanup, and reconciliation;
- camera adapter initialization, lifecycle, permission, shutter, Retake, and process interruption;
- OCR adapter mapping, Unicode preservation, missing/corrupt assets, isolation, and error categorization;
- Riverpod/widget Camera, Review, disabled controls, progress, error, Retry, restoration, and reactive status;
- end-to-end assigned/unassigned capture, repeated capture during OCR, restart at each boundary, and failed retry;
- English/Persian corpus accuracy and physical-device latency;
- screen-reader semantics, focus, contrast, 48dp targets, safe areas, RTL, large text, landscape, and reduced motion;
- production log inspection for protected data.

Normal automated tests use checked-in fakes and licensed fixtures, not a live camera or network. Corpus and physical-device suites are separately tagged release gates.

The specification is ready for approval only when it is consistent with Reading Session, model/corpus provenance is reviewable, and no blocking review concern remains. Implementation is complete later only when CB-01 through CB-12 pass.
