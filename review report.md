# BookBite Specification Review Report

**Review date:** 2026-07-27  
**Scope:** All Markdown specifications under `docs/`  
**Method:** Architecture, security, quality, user-advocacy, and governance review  
**Change policy:** Review only. No existing specification was modified.

## Executive Summary

**Overall decision: Major revision required before Library implementation.**

The specification set has a strong and unusually consistent product identity: reader-first, calm, local-first, multilingual, and centered on frictionless capture. The documents also establish a sensible high-level separation between the personal Library, catalog-facing Discover experience, My Book, Reading Sessions, and Bites.

The current material is sufficient for product direction and early design exploration, but not yet sufficient as an implementation contract. The Library feature specification describes the intended feeling and visual metaphor well, while leaving core behavior, data ownership, offline operation, accessibility, performance thresholds, failure handling, and verifiable acceptance criteria undefined.

### Blocking concerns

1. **The Library spec has no measurable acceptance criteria or verification strategy.** Terms such as “fast,” “immediate,” “welcoming,” and “meaningful” cannot produce deterministic tests or an approval decision ([Library spec, lines 202–215](docs/features/library/spec.md), [states, lines 256–270](docs/features/library/spec.md)).
2. **The personal-book data contract is incomplete.** Identity, duplicate handling, catalog linkage, manually created books, ordering, status ownership, deletion, and persistence behavior are not defined, even though offline-first local storage is mandatory ([domain model, lines 16–45](docs/domain-model.md), [architecture, lines 94–102](docs/architecture.md)).
3. **The Add Book flow conflicts with MVP scope.** The MVP explicitly permits manual book creation when catalog lookup fails, but the Library spec only routes through Discover and catalog search ([MVP scope, lines 32–41](docs/mvp-scope.md), [Library spec, lines 130–145](docs/features/library/spec.md)).
4. **Required engineering decisions are still open.** State management, local database, dependency injection, routing, testing, authentication, and synchronization are unselected ([tech stack, lines 170–185](docs/tech-stack.md)). At minimum, the local database, state ownership, routing contract, and test framework must be decided before the Library can be implemented without rework.
5. **Offline and synchronization semantics are missing.** The documents require local data to remain authoritative, but do not define mutation queues, conflict handling, deletion propagation, catalog metadata refresh, or anonymous-to-account migration ([MVP scope, lines 103–135](docs/mvp-scope.md)).
6. **Security and privacy requirements are declarative rather than actionable.** “Private by default” and “stored securely” lack a data classification, encryption policy, account boundary, export/delete behavior, telemetry limits, or rules for cached covers and OCR images ([tech stack, lines 148–154](docs/tech-stack.md)).
7. **Accessibility and RTL requirements are absent from the Library feature contract.** Global specifications require screen-reader support, dynamic text, touch targets, and native Persian RTL layout, but the bookshelf/spine interaction does not say how these work ([design system, lines 175–199](docs/design-system.md), [Library spec, lines 54–68](docs/features/library/spec.md)).

### Highest-value improvements

1. Add a normative “Library MVP contract” containing numbered requirements and testable acceptance criteria.
2. Define the `PersonalBook`/catalog-record boundary and the complete local persistence lifecycle.
3. Reconcile catalog addition with manual creation and offline behavior.
4. Specify the minimum Library slice separately from future personalization and environmental effects.
5. Add explicit performance, accessibility, localization, security, and error-recovery criteria.
6. Record the rendering, persistence, and synchronization choices as ADRs before implementation.

## Specifications Reviewed

| Document | Role in the specification set | Readiness |
|---|---|---|
| `docs/vision.md` | Product purpose, audience, and value proposition | Strong direction; validation metrics missing |
| `docs/constitution.md` | Non-negotiable product principles | Strong principles; enforcement rules missing |
| `docs/mvp-scope.md` | MVP boundaries and capabilities | Broadly coherent; too many items lack measurable completion criteria |
| `docs/domain-model.md` | Shared concepts and relationships | Useful vocabulary; entities, invariants, and lifecycle rules incomplete |
| `docs/architecture.md` | Architectural principles and layer boundaries | Sound direction; component and data-flow design incomplete |
| `docs/tech-stack.md` | Technology standards | Key implementation decisions remain open |
| `docs/app-navigation.md` | Global destinations and flows | Clear separation of contexts; unresolved state and route behavior |
| `docs/design-system.md` | Experience and interaction principles | Good principles; tokens, component constraints, and measurable accessibility missing |
| `docs/features/library/spec.md` | Library feature contract | Strong concept; major revision needed before implementation |

## Cross-Specification Findings

### What passes

- The core promise is consistent across vision, constitution, MVP, and design guidance: preserve meaningful reading moments without disrupting reading ([vision, lines 7–21](docs/vision.md), [constitution, lines 13–27](docs/constitution.md)).
- Local-first ownership is consistently stated across product, architecture, and technology documents ([constitution, lines 30–45](docs/constitution.md), [architecture, lines 94–102](docs/architecture.md), [tech stack, lines 56–72](docs/tech-stack.md)).
- Library and Discover have distinct responsibilities, which reduces catalog/personal-domain coupling ([navigation, lines 43–83](docs/app-navigation.md)).
- The Book Overview versus My Book distinction is conceptually useful and aligns catalog information with personal reading state ([navigation, lines 140–177](docs/app-navigation.md)).
- The domain supports multiple reading attempts through Reading Cycles and permits rapid unassigned Bite capture ([domain model, lines 47–68](docs/domain-model.md), [lines 86–121](docs/domain-model.md)).
- English/Persian localization and RTL support are treated as architecture-level concerns rather than future polish ([constitution, lines 92–98](docs/constitution.md), [architecture, lines 145–151](docs/architecture.md)).

### What is at risk

#### Inconsistent or ambiguous terminology

- The domain reserves **Bite** for captured book moments and says to avoid `BookNote`, yet My Book lists both “Bites” and “Notes” without defining a separate Note entity ([domain model, lines 191–201](docs/domain-model.md), [Library spec, lines 119–126](docs/features/library/spec.md), [navigation, lines 163–175](docs/app-navigation.md)).
- `Book` currently combines catalog metadata, a physical copy, and user-specific reading status. This makes identity and synchronization ambiguous ([domain model, lines 16–30](docs/domain-model.md)).
- “Read previously added books” can imply ebook reading, although the product is focused on physical books and does not specify ebook content ([MVP scope, lines 103–114](docs/mvp-scope.md)).
- `Focus Reading Session`, `Focus Mode`, and `Reading Session` appear related but their exact state relationship is not defined ([MVP scope, lines 74–85](docs/mvp-scope.md), [navigation, lines 87–99](docs/app-navigation.md)).

#### Scope and dependency ambiguity

- Library personalization and gamification are presented as goals and dependencies, but many concrete manifestations are described as future possibilities. The minimum shippable Library cannot be inferred ([Library spec, lines 148–198](docs/features/library/spec.md), [dependencies, lines 274–282](docs/features/library/spec.md)).
- The Library spec depends on “Book Library Management,” but that capability has no separate contract.
- The global Capture Bite action must be available from Library, but the Library feature does not specify its placement, state, or behavior ([navigation, lines 199–214](docs/app-navigation.md)).
- Reading Session is a primary destination but is also entered from a book. Behavior when no session is active, no book is selected, or an unassigned Bite is captured is undefined ([navigation, lines 22–37](docs/app-navigation.md), [lines 181–195](docs/app-navigation.md)).

#### Non-verifiable product claims

- The MVP asks whether BookBite becomes a natural reading habit but defines no study design, baseline, activation metric, retention window, capture completion time, OCR success target, or acceptable interruption duration ([MVP scope, lines 192–198](docs/mvp-scope.md)).
- Performance requirements are qualitative throughout the documents ([architecture, lines 118–130](docs/architecture.md), [tech stack, lines 117–130](docs/tech-stack.md)).
- “Capturing a Bite should always be faster than writing a manual note” lacks a defined comparison method or target ([design system, lines 54–62](docs/design-system.md)).

#### Document integrity

- Several documents contain mojibake such as `â€”` and corrupted tree characters. This is not a product blocker, but it damages readability, searchability, copy/paste accuracy, and generated-agent context.
- There is no explicit document precedence rule. It is unclear which document wins when the feature spec, MVP scope, domain model, and navigation spec conflict.
- Requirements do not have stable identifiers, ownership, status, version history, or traceability from goal to feature to test.

## Architect Review

### What passes

- Clean Architecture, feature-first modularity, replaceable providers, and domain independence provide a sound starting direction ([architecture, lines 43–115](docs/architecture.md), [tech stack, lines 41–52](docs/tech-stack.md)).
- Library is correctly positioned as a personal domain, with catalog discovery kept outside it.
- Local storage as the source of truth supports the central offline requirement.
- The distinction among Library, My Book, Reading Cycle, Reading Session, and Bite can support future evolution without forcing social/catalog concerns into the core reading model.

### Blocking architecture concerns

1. **No implementable Library boundary.** Define presentation, application/use-case, domain, and data responsibilities for:
   - observing the local library;
   - adding a catalog book;
   - creating a manual book;
   - opening My Book;
   - updating status;
   - removing/restoring a personal book;
   - refreshing catalog metadata;
   - synchronizing when an account exists.
2. **Personal and catalog identity are conflated.** Introduce explicit concepts such as `CatalogBook`, `PersonalBook`, and optionally `BookEdition`/`PhysicalCopy`. Define IDs, optional catalog linkage, duplicate policy, and snapshot ownership.
3. **No source-of-truth or conflict rules beyond the slogan “local first.”** Specify how local writes, remote sync, metadata refresh, tombstones, and multi-device conflicts behave.
4. **Rendering complexity is unbounded.** A physical bookshelf with readable spines, animation, decoration, large collections, dynamic text, and RTL could range from simple Flutter widgets to a custom renderer. Select the MVP rendering strategy and performance envelope before implementation.
5. **Key technical choices are unresolved.** Decide the local database, state management approach, navigation mechanism, dependency injection approach, and testing stack.

### Architecture recommendations

- Define a minimal module contract:
  - `LibraryRepository.watchLibrary()`
  - `AddCatalogBook`
  - `CreateManualBook`
  - `RemovePersonalBook`
  - `OpenPersonalBook`
  - `UpdateReadingStatus`
- Specify reactive data flow: local database → repository stream → application state → Library UI.
- Treat catalog metadata as an imported snapshot with provenance; never require the catalog to render an already-added book.
- Define stable local IDs generated before any account or network operation.
- Use soft deletion/tombstones if future synchronization is expected.
- Establish collection-size targets and virtualization requirements.
- Keep decorations and environmental effects behind extension points and outside the MVP critical path.

## Security Review

### What passes

- Optional accounts reduce forced disclosure and allow immediate local use ([MVP scope, lines 123–135](docs/mvp-scope.md)).
- Privacy-by-default and local data ownership are explicit product principles.
- External OCR, catalog, authentication, and cloud services are intended to sit behind replaceable interfaces.

### Blocking security concerns

1. **No data classification.** Define sensitivity and retention for book metadata, reading status, progress, Bites, captured page images, OCR text, profile data, account identifiers, and diagnostics.
2. **No local protection model.** Specify whether the database and captured images require encryption at rest, how secrets/tokens are stored, and what happens on device backup or shared-device use.
3. **No authorization model for synchronization.** Every personal record must be scoped to its owning user; anonymous local records need a safe claim/merge process when an account is created.
4. **No cloud OCR consent/data-flow contract.** Define explicit consent, content sent, provider, retention, transport protection, retry behavior, offline fallback, and user-visible disclosure.
5. **No deletion/export guarantees.** Personal ownership should translate into delete, export, account deletion, and remote tombstone behavior.

### Security recommendations

- Add a data inventory and threat model before sync or cloud OCR implementation.
- Require secure platform storage for authentication secrets.
- Define least-privilege access rules and ownership checks for every future backend resource.
- Prevent sensitive OCR text or page images from appearing in logs, analytics, crash reports, or thumbnails outside protected app storage.
- Specify cache expiration and cleanup for catalog covers and temporary captures.
- Add abuse and input limits for imported images, metadata strings, and remote responses.

## Quality Review

### What passes

- The specifications consistently require loading, empty, error, offline, and feedback states ([architecture, lines 133–143](docs/architecture.md)).
- The Library spec at least names empty, populated, loading, and error states.
- Domain terminology and feature separation provide a basis for unit and integration testing.

### Blocking quality concerns

1. **No acceptance criteria.** There is no pass/fail definition for any Library requirement.
2. **No testing strategy.** Unit, widget, integration, persistence, migration, accessibility, localization, performance, and recovery tests are unspecified.
3. **No negative or edge cases.** Missing cases include duplicate books, missing titles/covers, very long Persian titles, thousands of books, database failure, corrupted image cache, catalog timeout, interrupted add, deleted catalog record, and anonymous/account merge.
4. **No measurable performance targets.** Define startup, first Library render, interaction latency, animation frame budget, memory, and large-library scrolling targets.
5. **No migration/versioning strategy.** A local-first database requires schema migration and rollback/recovery tests from the beginning.

### Proposed acceptance criteria

The following are proposed starting points, not approved product decisions:

- **LIB-001 Offline render:** After a book has been added, the complete Library and My Book entry point render in airplane mode without a network request.
- **LIB-002 Local durability:** A successfully added or manually created book remains available after process death and device restart.
- **LIB-003 Add from catalog:** Adding a catalog result creates exactly one personal-library record with a stable local ID and a retained metadata snapshot.
- **LIB-004 Manual fallback:** When catalog search is unavailable or has no match, the user can create a personal book with the minimum required fields.
- **LIB-005 Duplicate policy:** Re-adding the same catalog edition follows an explicitly selected behavior and never silently creates accidental duplicates.
- **LIB-006 Empty state:** An empty library exposes one clear, accessible Add Book action and does not imply data loss.
- **LIB-007 Open book:** Selecting a shelf item opens the correct My Book record, including when catalog connectivity is unavailable.
- **LIB-008 Recovery:** A storage or load failure shows a localized explanation and retry/recovery path without deleting existing records.
- **LIB-009 Accessibility:** Every book is reachable and identifiable through screen readers without relying on spine orientation, cover art, color, or animation.
- **LIB-010 RTL:** Persian layout mirrors intentionally, preserves readable spine titles, and keeps navigation semantics correct.
- **LIB-011 Text scaling:** Core actions and book identification remain usable at the supported maximum text scale.
- **LIB-012 Performance:** Define and meet a target for initial local render and scroll smoothness at an agreed collection size on the minimum supported Android device.
- **LIB-013 Capture access:** The global Capture Bite action remains reachable from every Library state.
- **LIB-014 Data ownership:** Removing a book follows a specified policy for its Reading Cycles, Sessions, and Bites and requires confirmation when data could be lost.

### Recommended test matrix

| Level | Required coverage |
|---|---|
| Domain unit tests | Identity, duplicates, status transitions, removal policy, ordering, invariants |
| Repository tests | CRUD, streams, transactions, offline reads, migration, failure recovery |
| Widget tests | Empty/populated/loading/error states, add/open actions, long text, missing assets |
| Accessibility tests | Semantics labels/order, touch targets, text scaling, reduced motion |
| Localization tests | English LTR and Persian RTL, pluralization, truncation, mirrored navigation |
| Integration tests | Catalog add, manual add, restart durability, offline launch, anonymous/account migration |
| Performance tests | First render, large-library scroll, animation frame time, memory/image-cache bounds |
| Security tests | Ownership rules, token storage boundaries, log redaction, delete/export behavior |

## User Advocate Review

### What passes

- The Library has a clear emotional purpose and a differentiated bookshelf concept.
- Empty-state tone is aligned with a welcoming, non-judgmental reading companion.
- Discover and Library are separated in a way users can plausibly understand.
- The design values calmness, ownership, and low cognitive load rather than engagement pressure.

### User-facing risks

- Spine-first recognition can fail for long titles, identical spines, Persian vertical text, low vision, dyslexia, or books with missing metadata.
- The Add Book journey may feel unnecessarily long because it requires Library → Discover → Search → Overview → Add, with no specified return behavior.
- Users cannot know what removing a book does to Bites, Sessions, or Reading Cycles.
- “Loading should feel immediate” does not say whether the last known Library is always shown, whether skeletons are appropriate for local data, or what stale catalog assets look like.
- The spec does not define sort/order behavior, status grouping, search/filtering within a large personal Library, or how users find a specific book.
- Gamification and decorations could compete with the primary capture workflow unless introduced after core usability is validated.
- Motion modeled on opening a physical book may harm performance or accessibility without reduced-motion behavior.

### User-experience recommendations

- Offer both “Search catalog” and “Create manually” from Add Book.
- Return users directly to the newly added My Book page or its visible shelf position; specify the behavior.
- Provide a non-visual accessible representation of each shelf item: title, author, status, and progress.
- Define reduced-motion behavior and avoid making animation a prerequisite for navigation.
- Specify default sorting and a scalable fallback view for large libraries.
- Preserve visible local content during refresh; external catalog failures should not replace the Library with an error screen.
- Test the shelf metaphor with Persian readers and users relying on large text or screen readers before treating it as fixed.

## Governance Review

### What passes

- The Library concept strongly follows the Reader First, Personal Ownership, Calm Experience, Product Consistency, and Inclusive Design principles.
- The spec keeps social and catalog concerns out of the core personal space.
- Future environmental effects are labeled as secondary rather than essential.

### Blocking governance concerns

1. **No specification quality gate.** SDD is named as the development method, but no required template, approval status, traceability rule, or Definition of Ready exists ([tech stack, lines 11–17](docs/tech-stack.md)).
2. **No precedence or conflict-resolution rule.** The manual-add contradiction demonstrates why one is needed.
3. **No ADRs for consequential choices.** Local persistence/sync, catalog-personal identity, and bookshelf rendering have long-lived tradeoffs.
4. **No requirement IDs or change history.** This prevents reliable mapping from specs to tasks, tests, commits, and releases.

### Governance recommendations

- Establish precedence: Constitution → Vision/MVP → domain/architecture/navigation/design → feature spec → implementation plan.
- Add metadata to feature specs: owner, status, version, last reviewed date, dependencies, unresolved questions, and approval record.
- Require numbered normative requirements and traceability to tests.
- Define “Ready for implementation” as: no blockers, all open questions resolved or explicitly deferred, acceptance criteria approved, required ADRs accepted, and test strategy present.
- Fix file encoding to UTF-8 and add a documentation lint/check.
- Create ADRs for:
  1. local database and migration strategy;
  2. local-first synchronization and conflict resolution;
  3. personal-book versus catalog identity;
  4. Library bookshelf rendering and accessibility fallback.

## Document-Specific Proposed Improvements

### `vision.md`

- Add measurable product outcomes: capture completion time, completion rate, return-to-reading time, OCR correction rate, activation, and retention.
- Define the baseline against which “less interruption” will be tested.
- Clarify whether the product supports only physical books or may later include ebook reading.

### `constitution.md`

- Translate principles into enforceable checks and define how exceptions are approved.
- Add explicit privacy, accessibility, and data portability principles or attach them to existing ownership/inclusive-design principles.
- Define how competing principles are prioritized beyond the single capture-friction example.

### `mvp-scope.md`

- Split must-have validation capabilities from optional progression/gamification.
- Replace qualitative success criteria with measurable targets.
- Clarify “read previously added books.”
- Define what “reliable OCR” means and what happens when only cloud OCR is available offline.
- Add lifecycle behavior for book removal, Bite retention, account creation, data merge, export, and deletion.

### `domain-model.md`

- Separate catalog metadata from a user's personal library record.
- Define entity identifiers, required fields, invariants, cardinalities, status transitions, timestamps, and deletion rules.
- Resolve Bite versus Note terminology.
- Define whether a Bite can reference a Book without a Reading Cycle and how reassignment affects history.
- Clarify whether a Reading Session must belong to exactly one Reading Cycle.

### `architecture.md`

- Add component boundaries, dependency direction, representative interfaces, and data-flow diagrams.
- Define local database transactions, synchronization boundaries, background work, and failure recovery.
- Add observability rules that preserve privacy.
- Replace qualitative performance statements with budgets.

### `tech-stack.md`

- Decide the minimum technologies needed for the first feature.
- Record selection criteria and ADR links rather than leaving a bare unresolved list.
- Add supported Android/API versions and minimum-device performance assumptions.
- Define dependency/version policy, static analysis, formatting, testing, and CI quality gates.

### `app-navigation.md`

- Define route/state behavior for no active Reading Session, deep links, back navigation, process restoration, and global Capture Bite.
- Reconcile whether Reading Session is always a primary destination or a contextual workspace.
- Specify post-add return behavior from Discover.
- Remove duplicated Profile entries in the navigation map.

### `design-system.md`

- Add implementable foundations: colors, typography, spacing, elevation, motion durations, breakpoints, touch-target minimums, contrast targets, and semantic patterns.
- Define reduced motion, dark mode/appearance behavior, text-scale limits, truncation rules, and RTL mirroring rules.
- Specify accessible alternatives to visual metaphors such as book spines and decorations.

### `features/library/spec.md`

- Add requirement IDs, exact MVP scope, explicit non-functional requirements, acceptance criteria, test strategy, data model references, and open questions.
- Include manual book creation and offline addition behavior.
- Define ordering, duplicate handling, removal, missing metadata, large collections, refresh, and recovery.
- Specify Capture Bite placement and behavior.
- Separate MVP shelf behavior from future decorations, themes, environmental changes, and social sharing.
- Add accessibility, RTL, reduced-motion, localization, privacy, and performance requirements.
- Replace the generic dependency list with links/contracts and identify which dependencies are hard blockers.

## Proposed Improvement Sequence

1. **Resolve product/domain contradictions**
   - Manual creation path
   - Bite versus Note
   - Physical book versus catalog record versus personal record
   - Reading Session/Focus Mode relationship
2. **Define the Library MVP boundary**
   - Required behaviors
   - Deferred personalization/gamification
   - Dependencies and post-add navigation
3. **Choose foundational engineering decisions**
   - Local database
   - State management
   - Routing
   - Testing stack
4. **Write ADRs and data contracts**
   - Identity
   - Persistence/migration
   - Synchronization/conflicts
   - Rendering/accessibility
5. **Add numbered acceptance criteria and test matrix**
6. **Run design validation**
   - English/Persian
   - Screen reader
   - Large text
   - Reduced motion
   - Small and large libraries
7. **Approve the revised spec before implementation**

## Definition of Ready for Library

Library should be considered ready for implementation only when:

- all seven executive blockers are resolved;
- the minimum MVP behavior is separated from future enhancements;
- data entities and lifecycle rules are approved;
- local/offline and synchronization behavior is explicit;
- security/privacy and accessibility requirements are testable;
- performance budgets and supported device assumptions are documented;
- every normative requirement maps to one or more tests;
- required ADRs are accepted;
- no unresolved contradiction remains among MVP, domain, navigation, and feature documents.

