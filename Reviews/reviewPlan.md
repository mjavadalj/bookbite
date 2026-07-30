# BookBite Core Specification Rewrite Plan

**Status:** Proposed  
**Prepared:** 2026-07-28  
**Rewrite targets:** Seven core specifications only  
**Excluded from this rewrite:** `app-navigation.md` and all feature specifications

## Executive Summary

BookBite has a strong and consistent product identity: a calm, offline-first mobile companion that helps readers preserve meaningful content from physical books without interrupting reading.

The seven core specifications communicate this philosophy well, but they are not yet precise and consistent enough to act as the sole source of truth for specification-driven development. Their rewrite should preserve the existing vision while clarifying terminology, MVP boundaries, domain relationships, architectural behavior, technology choices, accessibility requirements, privacy rules, and specification governance.

This plan covers only:

- `docs/vision.md`
- `docs/constitution.md`
- `docs/design-system.md`
- `docs/domain-model.md`
- `docs/mvp-scope.md`
- `docs/architecture.md`
- `docs/tech-stack.md`

`docs/app-navigation.md` and feature specifications, including the Library feature specification, will be rewritten later using the improved core documents.

No product feature should be introduced through this rewrite unless it is necessary to resolve an approved contradiction or make an existing decision implementable.

## Change Classification

- **Minor:** Editorial or structural correction that preserves meaning. Safe to apply automatically.
- **Medium:** Recommended clarification or completeness improvement that formalizes existing intent without materially changing the product.
- **Major:** Product scope, domain, architecture, or technology decision requiring explicit approval.
- **Major — Approved:** A Major decision explicitly resolved and approved during planning.

## Overall Assessment

### What is already strong

- The central product promise is clear and distinctive.
- Reader focus, calm interaction, performance, and local ownership are consistently valued.
- Physical-book capture is clearly more important than generic note management.
- Flutter, offline-first behavior, English/Persian localization, and Clean Architecture provide a coherent technical direction.
- The domain already identifies useful concepts such as Bite, Reading Cycle, Reading Session, and Reading Journey.
- The MVP intentionally excludes social and AI-heavy expansion.

### What needs improvement

- `Bite`, `Note`, `Book`, reading status, Focus Mode, and Reading Session are used ambiguously.
- Catalog metadata and personal-library data are conflated.
- Offline behavior is incomplete when OCR or book assignment is pending.
- The MVP currently includes accounts and synchronization even though they are not required to validate the core promise.
- Core requirements are mainly qualitative and provide insufficient guidance for later feature-level acceptance criteria.
- Several foundational technology choices remain unresolved.
- Accessibility, RTL behavior, privacy, retained image handling, destructive actions, migration, and recovery need enforceable rules.
- The seven documents do not define how peer specifications should handle overlapping statements or conflicts.

### Review-report correction

The existing `review report.md` incorrectly identifies source-file mojibake. The Markdown source files contain valid UTF-8 punctuation and tree characters. The apparent corruption was caused by PowerShell display decoding. No encoding rewrite should be performed on that basis.

## Document-by-Document Proposed Changes

### `vision.md`

#### Minor

- Correct grammar, punctuation, repetition, and inconsistent capitalization.
- Use `Bite` consistently as the product term.
- Retain “note-taking” only as plain-language description, not as a separate domain object.
- Replace vague references to captured “notes” where the text refers to a Bite.

#### Medium

- State the core workflow clearly:
  1. photograph a page from a physical book;
  2. preserve the image locally;
  3. perform on-device OCR;
  4. create editable Bite text;
  5. let the reader continue reading and edit the Bite later.
- Clarify that BookBite is not:
  - an ebook reader;
  - a generic notes application;
  - an AI summarizer;
  - a social platform.
- Distinguish primary physical-book readers from secondary academic and knowledge-oriented users without expanding the MVP.
- Separate enduring product vision from post-MVP possibilities such as cloud OCR, synchronization, and social functionality.
- Preserve the emotional reading-archive concept while making the functional promise more explicit.

#### Major

- None.

### `constitution.md`

#### Minor

- Normalize headings, punctuation, and terminology.
- Use consistent normative language:
  - `must` for non-negotiable requirements;
  - `should` for strongly preferred behavior;
  - `may` for permitted optional behavior.
- Replace ambiguous uses of “note” with Bite where appropriate.

#### Medium

- Strengthen Local First so the complete Bite workflow works offline from first launch, including:
  - unassigned capture;
  - durable image save;
  - on-device OCR;
  - viewing;
  - editing.
- Translate Personal Ownership into concrete principles:
  - user-created data remains local and accessible;
  - page images and OCR text are not silently discarded;
  - destructive actions are explicit;
  - permanent deletion requires confirmation.
- Add a calm-progression rule:
  - achievements, milestones, and ranks remain minimal;
  - they are predefined and non-competitive;
  - they never pressure the reader or dominate navigation.
- Add specification-governance rules:
  - all seven core documents are peer authorities;
  - each document owns a defined concern;
  - overlapping statements must remain semantically consistent;
  - conflicts block implementation and require user resolution;
  - feature specifications cannot silently override the core specifications.
- State that cloud-dependent processing must never become necessary for the MVP’s core workflow.

#### Major

- None.

### `design-system.md`

#### Minor

- Normalize terminology and remove vague or repetitive statements.
- Use Bite consistently.
- Replace subjective wording where an existing accessibility or interaction rule can express the intent more clearly.

#### Medium

- Add enforceable accessibility requirements for:
  - screen readers;
  - English LTR and Persian RTL;
  - dynamic text;
  - contrast;
  - touch targets;
  - focus order;
  - non-visual alternatives to physical metaphors.
- Add reduced-motion behavior. Animation may reinforce feedback or navigation but cannot be required to understand or complete an action.
- Define standard presentation states for:
  - local data loading;
  - background OCR processing;
  - recoverable OCR failure;
  - missing or deleted page images;
  - offline external-service unavailability;
  - empty content.
- Require immediate confirmation when a page image has been saved durably, even if OCR is still processing.
- Require every later feature specification to define measurable interaction and animation performance budgets.
- Add calm-progression constraints:
  - no leaderboards;
  - no competitive comparisons;
  - no streak-loss pressure;
  - no reward-first navigation;
  - no shame or urgency language.
- Define required design-token categories:
  - color;
  - typography;
  - spacing;
  - shape;
  - elevation;
  - motion;
  - semantic states.
- Leave exact visual token values to a later dedicated design-system implementation pass.

#### Major

- None.

### `domain-model.md`

#### Minor

- Replace the current relationship tree with a maintainable relationship diagram.
- Expand the terminology table to cover every canonical entity and prohibited synonym.
- Use singular entity names consistently.

#### Medium

- Add stable identifiers, required fields, timestamps, ownership, cardinalities, lifecycle invariants, and reassignment rules.
- Define catalog import provenance and duplicate behavior:
  - importing the same provider edition resolves to the existing PersonalBook;
  - a different edition or translation may create a separate PersonalBook.
- Add Bite OCR states:
  - captured;
  - processing;
  - ready;
  - failed.
- Define recovery after application termination during OCR.
- Specify that deleting a retained page image does not implicitly delete the Bite’s editable OCR text.
- Define reassignment history for unassigned Bites and Reading Sessions.
- Define the relationship among archived PersonalBooks, Reading Cycles, Reading Sessions, and Bites.

#### Major — Approved

- Replace the overloaded `Book` concept with:
  - `CatalogBook`: metadata and identity supplied by an external catalog provider;
  - `PersonalBook`: the reader-owned local record for one edition/title, optionally linked to a CatalogBook.
- Represent different editions or translations as separate PersonalBooks.
- Represent rereads of the same PersonalBook as separate ReadingCycles.
- Make ReadingCycle the owner of lifecycle status.
- Let PersonalBook expose a derived current status, with `Want to Read` before the first ReadingCycle begins.
- Make Bite the only captured-content entity. Do not add a separate Note or AI Summary entity.
- Allow ReadingSessions and Bites to exist unassigned.
- Define Focus Mode as optional distraction-reduced UI behavior inside a ReadingSession, not as a separate domain activity.
- Make a Bite linked to a ReadingSession inherit the session’s later PersonalBook and ReadingCycle assignment unless explicitly detached or reassigned.
- Archive a removed PersonalBook by default and preserve all history.
- Make permanent deletion a separate, explicit, confirmed operation.
- Retain the original page image locally with the Bite until the user explicitly deletes it.

### `mvp-scope.md`

#### Minor

- Apply canonical terms consistently.
- Move AI-generated summaries, AI refinement, cloud OCR, accounts, synchronization, and social features unambiguously into post-MVP or out-of-scope sections.
- Clarify that “read previously added books” means access PersonalBooks and their reading history, not read ebook content.

#### Medium

- Define the capture contract:
  1. save the image durably;
  2. create a pending Bite;
  3. process OCR locally;
  4. persist editable text or a recoverable failure;
  5. retain both text and source image.
- Rewrite success criteria as capability-level outcomes.
- Require every later feature specification to define measurable performance, accessibility, quality, and reliability thresholds.
- State that manual PersonalBook creation supplies the complete fallback when catalog lookup is unavailable or has no result.
- Define English as the primary OCR release-quality target.
- Include Persian OCR as a secondary MVP priority whose measurable quality target belongs in the OCR feature specification.
- Clarify that the minimum progression system is extensible but must not dominate the Library or reading workflow.
- Use a replaceable catalog abstraction, locally cache imported metadata, and prevent catalog failure from affecting existing PersonalBooks.

#### Major — Approved

- Make the MVP account-free and fully local.
- Defer accounts, cloud backup, and cross-device synchronization.
- Require free, on-device OCR for the MVP.
- Exclude cloud OCR and paid OCR services from the MVP.
- Retain minimal predefined achievements, milestones, and ranks under calm and non-competitive constraints.
- Retain external book discovery through a free API.
- Use Open Library as the initial free catalog provider while keeping the provider replaceable.
- Require the complete Bite workflow to operate offline from first launch.

### `architecture.md`

#### Minor

- Normalize terminology and cross-document references.
- Make examples align with CatalogBook, PersonalBook, ReadingCycle, ReadingSession, and Bite.

#### Medium

- Refine Clean Architecture into feature-first modules with:
  - presentation;
  - application;
  - domain;
  - data responsibilities.
- Define dependency direction:
  - presentation depends on application;
  - application coordinates domain behavior;
  - domain remains framework-independent;
  - data implements interfaces required by application/domain.
- Define local data as the only MVP source of truth.
- Treat catalog data as imported and cached metadata, never as a runtime requirement for displaying an existing PersonalBook.
- Add replaceable interfaces for:
  - OCR;
  - catalog discovery;
  - file storage;
  - IDs and clock;
  - future synchronization.
- Define reactive flow from Drift queries through application state to Riverpod presentation state.
- Add transaction, migration, corruption recovery, background-work, archive, and permanent-deletion boundaries.
- Specify that structured data lives in SQLite while page images live in app-private file storage with database-managed references.
- Add privacy rules:
  - OCR text and page images never appear in production logs;
  - sensitive content is excluded from analytics and crash payloads;
  - temporary images are cleaned up safely.
- Keep future cloud OCR and synchronization behind optional adapters that cannot redefine the MVP domain.
- Require every feature architecture section to address:
  - loading;
  - empty states;
  - errors;
  - offline behavior;
  - recovery;
  - localization;
  - accessibility;
  - measurable performance.

#### Major — Approved

- Define a durable local OCR pipeline:
  1. capture the image;
  2. persist the image and pending Bite;
  3. enqueue on-device OCR;
  4. persist extracted text or recoverable failure;
  5. expose processing state reactively;
  6. resume incomplete work after restart.
- Standardize SQLite as structured persistence.
- Standardize app-private file storage for retained page images.

### `tech-stack.md`

#### Minor

- Replace the unresolved technology list with a decision table containing:
  - technology;
  - purpose;
  - MVP status;
  - constraints;
  - review trigger.
- Pin exact dependency versions in project configuration, not long-lived prose.
- State that the current stable Flutter/Dart SDK is selected and pinned when the application project is bootstrapped.

#### Medium

- Use Open Library as the initial free catalog provider behind an adapter.
- Use the official Dart `http` Client for catalog requests.
- Use official Flutter camera and path-provider packages.
- Use Flutter localization with ARB resources and `intl`.
- Standardize testing on:
  - `flutter_test`;
  - `integration_test`;
  - Riverpod container tests;
  - Drift repository tests;
  - Drift migration tests;
  - selective golden tests;
  - fakes before mocks where practical.
- Standardize code quality on:
  - `dart format`;
  - strict analyzer settings;
  - Flutter lints;
  - generated-code verification;
  - dependency review.
- Use GitHub Actions for format, analysis, unit/widget tests, migration tests, and Android integration checks.
- Ship no backend, authentication, synchronization, cloud OCR, remote analytics, or remote crash-reporting SDK in the MVP.
- Use privacy-safe local diagnostics during development.

#### Major — Approved

- Use Riverpod 3 with code generation for application and presentation state plus dependency wiring.
- Keep domain entities and rules independent from Riverpod.
- Use Drift over SQLite for typed persistence, relational queries, transactions, reactive streams, migrations, and isolated database work.
- Use generated typed `go_router` routes.
- Use Dart’s official `http` package behind catalog-service interfaces.
- Use Tesseract 5 behind a Dart OCR interface and isolated native platform adapters.
- Bundle free English and Persian OCR models.
- Treat English OCR quality as the primary MVP release gate and Persian as a secondary MVP priority.
- Do not use paid OCR or third-party cloud OCR in the MVP.

## Cross-Document Consistency Issues

The rewrite must resolve these issues across all seven documents:

1. **Bite versus Note**
   - Bite is canonical.
   - “Note-taking” is descriptive language only.

2. **OCR output versus summaries**
   - MVP OCR creates editable Bite text.
   - It does not create AI summaries.

3. **Book identity**
   - CatalogBook and PersonalBook are distinct.
   - External metadata never owns personal reading history.

4. **Reading status**
   - ReadingCycle owns lifecycle status.
   - PersonalBook derives its current status.

5. **Offline scope**
   - The full Bite workflow operates offline from first launch.
   - A PersonalBook is not required before capture.

6. **OCR provider**
   - MVP OCR is free and on-device.
   - Future cloud OCR may be free or paid but remains optional and post-MVP.

7. **Source-image retention**
   - The original page image is retained locally.
   - The user may delete it explicitly.

8. **Accounts and synchronization**
   - They are post-MVP.
   - The architecture remains extensible without implementing them.

9. **Gamification**
   - Minimal achievements, milestones, and predefined ranks remain in MVP.
   - They are calm and non-competitive.

10. **ReadingSession and Focus Mode**
    - ReadingSession is the domain activity.
    - Focus Mode is optional presentation behavior.

11. **Unassigned history**
    - ReadingSessions and Bites may be assigned later.
    - Bites linked to a session inherit its assignment by default.

12. **PersonalBook removal**
    - Removal archives by default.
    - Permanent deletion is separate and confirmed.

13. **Performance**
    - Core documents require measurable feature budgets.
    - Feature specifications define the actual numeric targets.

14. **Specification authority**
    - All seven documents remain peers.
    - Each owns a distinct concern.
    - Conflicts are never resolved silently.

15. **Encoding**
    - Existing source UTF-8 is valid.
    - No mojibake rewrite is required.

## Approved Major Decisions

- The seven core documents remain peer authorities.
- Only the seven named core documents are rewrite targets.
- CatalogBook and PersonalBook become separate domain entities.
- One PersonalBook represents one edition/title.
- Rereads use separate ReadingCycles.
- ReadingCycle owns status; PersonalBook derives it.
- Bite is canonical; Note and AI Summary are not separate entities.
- OCR output is editable Bite text, not an AI summary.
- MVP OCR is free and on-device.
- English OCR is the primary release-quality target.
- Persian OCR remains a secondary MVP priority.
- The original page image is retained locally with the Bite.
- Complete unassigned Bite capture works offline from first launch.
- ReadingSession is the tracked activity; Focus Mode is optional UI.
- ReadingSessions may be unassigned.
- Session-linked Bites inherit session assignment by default.
- PersonalBook removal archives by default.
- Accounts, cloud backup, and cross-device synchronization are post-MVP.
- Minimal achievements, milestones, and predefined ranks remain in MVP.
- Book discovery uses a free external API with manual creation as fallback.
- Riverpod 3 with code generation is selected.
- Drift with SQLite is selected.
- Typed `go_router` is selected.
- The official Dart `http` package is selected.
- Tesseract 5 with native adapters is selected.

## Open Questions Requiring Future Approval

These questions do not block rewriting the seven core specifications, but must be resolved before their affected implementation begins:

1. What minimum Android API level will the MVP support?
2. Which low-end Android device or device profile will be the performance reference?
3. Does MVP require encryption beyond operating-system app-private storage for the SQLite database and retained page images?
4. What English and Persian OCR accuracy and latency thresholds must the OCR feature satisfy?
5. Which predefined ranks, milestones, and achievements form the minimum progression set?
6. Which backend, authentication, sync, cloud OCR, analytics, or crash-reporting providers may be considered after MVP?

No provider in item 6 is authorized for MVP by this plan.

## Recommended Execution Order

1. Rewrite `vision.md` and `constitution.md` to establish canonical product language and governance.
2. Rewrite `mvp-scope.md` to establish the approved MVP boundary.
3. Rewrite `domain-model.md` with the approved entities, relationships, and lifecycle rules.
4. Rewrite `architecture.md` around durable local capture, OCR processing, persistence, recovery, and adapter boundaries.
5. Rewrite `tech-stack.md` with the approved technology decisions and MVP exclusions.
6. Rewrite `design-system.md` with operational accessibility, RTL, feedback, background-processing, and calm-progression rules.
7. Review the seven documents together and resolve any remaining contradiction.
8. Validate:
   - Markdown structure;
   - UTF-8 decoding;
   - internal links;
   - canonical terminology;
   - MVP scope boundaries;
   - domain-to-architecture coverage;
   - technology-to-architecture alignment;
   - accessibility and RTL coverage.
9. Present the seven rewritten documents as one approval set.
10. After approval, use the core specifications to rewrite navigation and create feature specifications one at a time.

## Rewrite Acceptance Criteria

The rewrite is complete only when:

- all seven documents are internally consistent;
- all seven documents work together as peer sources of truth;
- every domain term has one canonical definition;
- every MVP capability has supporting domain, architecture, technology, and UX rules;
- the reader-first, calm, local-first, physical-book vision is preserved;
- no unapproved feature is introduced;
- all approved Major decisions are visible and traceable;
- remaining Major decisions are explicitly listed instead of guessed;
- later feature specifications can derive measurable acceptance criteria without reinterpreting core product decisions;
- `app-navigation.md` and feature specifications remain unchanged during this rewrite phase.

