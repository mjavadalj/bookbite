# Feature Specification: CatalogBook Detail

**Status:** Proposed

**Feature owner:** Catalog

**MVP platform:** Android, preserving future iOS compatibility

**Last updated:** 2026-08-10

## 1. Purpose

CatalogBook Detail lets a reader verify an external catalog record before adding a local `PersonalBook`. It must present trustworthy metadata in the approved calm, cover-led layout, remain useful from cache when offline, and return to the exact Discover context that opened it.

This page is catalog evaluation, not a reading, social, review, recommendation, or capture surface.

## 2. Authority and scope

This specification is governed by:

- `docs/vision.md`;
- `docs/constitution.md`;
- `docs/mvp-scope.md`;
- `docs/domain-model.md`;
- `docs/architecture.md`;
- `docs/tech-stack.md`;
- `docs/design-system.md`;
- `docs/app-navigation.md`;
- `docs/features/discover/spec.md`;
- `docs/design/catalog-flow/catalog-flow-ux.md`;
- `docs/design/catalog-flow/approved-mvp/02-catalog-book-hero.png`;
- `docs/design/catalog-flow/approved-mvp/03-catalog-book-scrolled.png`; and
- the CatalogBook Detail milestone in `docs/roadmap.md`.

### In scope

- typed CatalogBook Detail route and restoration;
- approved hero and pinned collapsing header;
- validated full metadata and missing-field handling;
- related catalog books;
- detail loading, refresh, offline, error, retry, and missing-cover states;
- five-entry disposable full-detail cache with LRU eviction;
- Add-to-Library integration contract and saved state;
- English LTR, Persian RTL, mixed-direction metadata, accessibility, dynamic text, and reduced motion; and
- provider-neutral repository, Open Library adapter, tests, and performance criteria.

### Out of scope

- Discover browse/search behavior already owned by its approved spec;
- PersonalBook schema, transactional import, deduplication, and rollback rules;
- PersonalBook Detail implementation;
- manual book creation;
- reviews, ratings, previews, purchase or availability links;
- personalized recommendations or use of Library/Journey data for related books;
- Photo, Voice, OCR, speech-to-text, or reading-session behavior;
- accounts, analytics, cloud services, alternate providers, or theme selection.

## 3. Fixed decisions

1. A `CatalogBook` is external provider metadata and owns no personal state.
2. Route identity is provider plus provider-specific edition/book ID. Work ID remains optional provenance.
3. The page uses the approved Sage and Paper design and shared tokens; no page-local theme or ad-hoc colors are introduced.
4. Full-detail cache is disposable, separate from Discover summary cache and permanent PersonalBook snapshots.
5. At most five full-detail entries are retained. Every successful cache open updates LRU recency.
6. Related books are deterministic provider results based on shared catalog subjects. They are not personalized recommendations.
7. Missing provider fields are omitted. BookBite never invents, translates, summarizes, or corrects metadata.
8. Detail and related requests fail independently. Related failure never replaces otherwise usable detail.
9. CatalogBook Detail exposes no main navigation, Photo, or Voice controls.
10. Add/import behavior remains owned by its separate feature; this page owns only its visible action and integration states.

## 4. Route and page relationships

### Route

`/catalog/:provider/:id?origin=<browse|weekly|search>`

- Use the existing typed `CatalogBookDestinationRoute` and restoration ID.
- Accept only a recognized provider namespace and syntactically valid provider identity.
- Invalid parameters render a localized unavailable state and never make a request.
- Preserve the route identity across process restoration.

### Entry and back

| Entry | Required return behavior |
|---|---|
| Discover Browse | Restore loaded batches, category-rail position, vertical anchor, and focus when available. |
| Explore this week | Restore shelf position, root vertical anchor, and focus. |
| Active Search | Restore visible query, selected results, loaded batches, scroll anchor, field/focus state, and keyboard state where supported. |
| Related book | Back returns to the prior CatalogBook Detail with its scroll position and cached state. |
| External/deep route | Back follows the router stack, then the normal Discover/root fallback. |

- System Back and the visible Back control perform the same pop.
- The page performs no write merely by opening, scrolling, retrying, or navigating back.
- Reselecting Discover follows the global destination-stack rule.

### Add-to-Library contract

- The primary action passes the validated full-detail snapshot and provider provenance to the separate import use case.
- While import is pending, disable repeat activation, preserve the page, and show inline progress in the same action bounds.
- On failure, restore the Add action and show localized recoverable feedback without discarding the detail.
- On success, replace Add with a confirmed `Saved` state and retain the permanent PersonalBook snapshot outside catalog caches.
- While PersonalBook Detail is deferred, remain on this page as required by the roadmap.
- Once PersonalBook Detail exists, successful import opens that local record as required by global navigation.
- Opening an already imported provider edition shows `Saved`; activation may open PersonalBook Detail when that route exists.
- Catalog cache eviction must never alter the imported PersonalBook or its history.

## 5. Approved presentation

Use one vertical `CustomScrollView`-style surface with safe-area-aware slivers. Match the approved composition and hierarchy; adapt only where localization, text scale, orientation, or device width requires it.

### Initial hero

Order:

1. top-safe-area Back control;
2. large centered 2:3 cover with restrained natural shadow;
3. centered title;
4. centered locale-formatted authors;
5. centered subject chips, using at most the first three useful subjects;
6. short description excerpt when available;
7. full-width primary `Add to your library` action;
8. shield/check helper row: metadata will be saved locally for offline access after import;
9. hairline divider; and
10. `About this book` continuation heading.

Rules:

- Use Canvas `#F3EFE6`, shared foreground/secondary/border/primary tokens, 24dp phone gutters, 8dp rhythm, and 16-24dp radii.
- The cover is the visual focal point but never the sole book identifier.
- Reserve the cover aspect ratio before the image loads. Use the shared missing-cover treatment on absent or failed images.
- Title and authors wrap; do not truncate essential identity.
- Omit the subject row or description excerpt when unavailable; do not leave blank gaps.
- The helper describes local ownership. It must not imply the catalog record itself is already saved or synced.
- The continuation affordance may disappear once the content section reaches the pinned header; it is not a collapsible About section.

### Scrolled state and pinned header

When the body CTA has fully left the viewport, pin a compact header containing:

1. Back;
2. small 2:3 cover thumbnail;
3. title and authors;
4. compact `Add` or `Saved` action; and
5. bottom hairline divider.

- The body and header Add controls must never be visible at the same time.
- Transition within the shared 180ms motion token and do not shift body layout.
- Reduced motion switches header states without interpolation, parallax, fading travel, or cover morphing.
- At large text, allow the header to grow or use a two-row arrangement; do not hide Back, identity, or Add/Saved.
- Keep all controls outside status/navigation gesture regions and at least 48x48dp.

### Content sections

#### About this book

- Show the provider description as plain localized-direction text.
- Support a string or provider text object after adapter normalization.
- Preserve paragraph breaks within limits; strip markup/control characters at the adapter boundary.
- If absent, omit the section body rather than generate a summary.

#### Details

Use sparse key/value rows separated by hairlines. Display available values in this order:

1. Author;
2. Publication date or first-published date;
3. Edition;
4. Original/edition language;
5. Page count;
6. ISBN-13;
7. ISBN-10; and
8. additional validated provider identifiers only when useful.

- Omit absent rows and empty separators.
- Keep labels localized and values in their natural direction.
- Dates remain provider text unless a safely parsed value can be locale-formatted without losing precision.
- Page count must be a positive integer; invalid values are absent.
- Do not infer original language from UI locale or edition language.

#### Related catalog books

- Render only when at least one valid related result exists.
- Use the approved horizontal cover shelf with title and authors below each 2:3 cover.
- Show up to 10 unique results, excluding the current work and exact edition.
- Preserve provider order after validation and deduplication.
- Activation pushes another CatalogBook Detail route and retains this page beneath it.
- The shelf supports touch, keyboard/Switch Access, and screen-reader next/previous scrolling; it cannot require swipe alone.
- If related loading is below the fold, use reserved placeholders without blocking or moving the detail above it.
- Related empty/error states are omitted silently; a retry is included with the page refresh, not as a noisy standalone error card.

## 6. Domain and application contracts

Extend the existing catalog boundary rather than the placeholder `features/catalog` interface.

```dart
abstract interface class CatalogRepository {
  Future<CatalogBookDetail> detail({
    required String provider,
    required String id,
    String? workId,
    required String language,
  });

  Future<List<CatalogBook>> related({
    required CatalogBookDetail book,
    required String language,
    int limit = 10,
  });
}
```

`CatalogBookDetail` is a pure-Dart validated catalog model containing:

- provider, edition/book ID, optional work ID, and provenance;
- required title;
- authors;
- cover reference;
- description;
- subjects;
- publication date and optional first-published year;
- edition label;
- edition language and optional original language;
- positive page count;
- ISBN-10/ISBN-13 and other useful identifiers; and
- fetch timestamp/source needed for cache presentation.

Application state is one immutable page state with independently represented detail and related status:

- `loading`, `data`, `refreshing`, `offline`, or `failure` for detail;
- `idle`, `loading`, `data`, or `failure` for related; and
- `notSaved`, `saving`, `saved`, or `saveFailure` for import integration.

The controller must reject stale responses by route request identity and must not update state after disposal.

## 7. Open Library adapter

All calls reuse the existing configured contact, `User-Agent`, JSON acceptance, global request spacing, timeout, response-size bounds, typed failures, and privacy-safe logging.

### Full detail

| Route identity | Calls | Purpose |
|---|---|---|
| Edition `OL…M` | `GET /books/{editionId}.json` | Exact edition title, subtitle, authors, publishers, publish date, languages, pagination, identifiers, covers, and referenced work. |
| Referenced work `OL…W` | `GET /works/{workId}.json` | Description, subjects, first publication, work cover fallback, and work-level author references. |
| Work-only route | `GET /works/{workId}.json`, then `GET /works/{workId}/editions.json?limit=10` | Work metadata plus deterministic representative edition, preferring route language, then a covered valid edition. |
| Missing author names | `GET /authors/{authorId}.json` | Resolve only unresolved referenced authors; deduplicate IDs and cap/constrain concurrent calls. |

- Validate every key against `^OL\\d+[MWA]$` before constructing a path.
- Edition values take precedence for edition-specific fields; work values fill only work-level or absent fields.
- Prefer an edition cover, then work cover, then the shared placeholder.
- Do not use `fields=*`, availability, ratings, reviews, reading links, or provider-generated summaries.
- Partial valid responses render. Required identity/title failure is `invalidResponse`, not an empty page.

### Similar books

After usable detail is available and at least one validated subject exists:

`GET /search.json?q=<subject query>&fields=key,title,author_name,edition_key,cover_i,language,first_publish_year,isbn&lang=<ui language>&limit=20`

- Build a bounded OR query from at most three normalized provider subjects.
- Use provider relevance order; do not sort by ratings, popularity pressure, Library data, or reading history.
- Map through the existing CatalogBook summary validator.
- Remove the current work/edition, malformed results, and duplicates, then keep the first 10.
- No subjects means no request and no related section.
- The Subjects API is not required; its experimental contract must not become an MVP dependency.

## 8. Cache and offline behavior

- Store full-detail entries in a dedicated Drift-backed disposable cache keyed by `provider:id`.
- A cached entry includes validated detail plus its related summary list, fetched/updated time, and last-access time.
- Keep at most five entries. After a successful write or read, evict least recently accessed entries in one tested operation.
- A related book summary inside an entry does not count as another full-detail entry.
- Treat entries as fresh for seven days. Render fresh cache without a network request.
- Render stale cache immediately, mark refresh state without clearing content, and refresh in the background when online.
- Any successful cache open updates LRU recency, including offline opens.
- Offline with cache shows the complete cached page and calm localized offline/cached status.
- Offline or provider failure without cache shows a recoverable unavailable state with Retry, Back, and manual PersonalBook creation.
- A malformed disposable entry is removed or ignored without clearing other cache entries or personal data.
- Cache writes are atomic/best effort; a write failure must not hide already fetched valid detail.
- PersonalBook snapshots use separate tables/repositories and are never subject to detail-cache eviction.

## 9. State presentation and recovery

| State | Presentation |
|---|---|
| First load, no cache | Stable skeleton matching hero geometry; Back remains active. No decorative shimmer with reduced motion. |
| Cached/fresh | Render immediately. |
| Cached/stale refresh | Keep content interactive; show low-emphasis refresh status. |
| Offline with cache | Keep content and related shelf; label as saved catalog copy/offline. |
| Offline/no cache | Localized connection-needed message, Retry, Back, and primary manual-create fallback. |
| Provider unavailable/timeout/rate limit | Preserve any cache; otherwise show recoverable unavailable state. Respect `Retry-After`. |
| Malformed/invalid identity | Unavailable state; no invented data and no unsafe retry loop. |
| Missing cover | Reserved 2:3 placeholder with book semantics supplied by adjacent text. |
| Missing optional metadata | Omit only the affected field or section. |
| Related loading/failure/empty | Detail remains usable; reserve then omit related content without full-page error. |
| Import pending/failure/success | Same-bounds progress, recoverable feedback, then Saved state; never duplicate writes. |

Retry refreshes detail and related data for the current identity while retaining valid cache. Manual creation receives origin plus a title seed only when a validated title is available.

## 10. Accessibility, localization, and interaction

- Localize every user-facing string in English and Persian.
- Mirror Back direction, header arrangement, alignment, and focus order in RTL; keep cover artwork unmirrored.
- Isolate title, author, identifiers, dates, and mixed-language values in their natural direction.
- Reading order: Back, hero identity, subjects, description excerpt, Add/helper, About, Details, Related; pinned duplicate identity is excluded from repeated semantics where appropriate.
- Cover semantics announce title and authors once; decorative shadows and placeholder art are excluded.
- Add announces button, saving/disabled state, success, and recoverable failure.
- Section titles expose header semantics. Detail rows announce label and value together.
- All controls are at least 48x48dp with 8dp separation, visible press/focus feedback, and WCAG 2.2 AA contrast.
- Support largest platform text without clipping essential actions. Switch the related shelf to a more readable adaptive layout when text cannot fit safely.
- Standard Back gesture remains available. No essential action relies on hover, swipe, color, imagery, or animation.
- Respect safe areas, landscape, tablets, external keyboards, TalkBack, Switch Access, and reduced motion.

## 11. Performance and privacy

- Tap/press feedback begins within 100ms.
- Cached detail becomes usable within 200ms p95 after route construction on the reference device.
- A valid network response begins rendering within 100ms of adapter completion.
- Maintain 60fps scrolling; reserve image/header/related geometry to avoid visible layout jumps.
- Fetch the hero cover at an appropriate display size; load related covers lazily with bounded concurrency.
- Do not start related lookup until usable detail is available.
- Coalesce duplicate detail requests for the same identity and cancel/reject obsolete work.
- Production diagnostics may include provider, endpoint class, failure kind, status, timing, and response size, but never payload bodies, descriptions, queries/subjects, titles, authors, ISBNs, or personal data.
- No catalog data is uploaded anywhere except requests required to Open Library; personal content is never sent.

## 12. Acceptance criteria

### AC-01 — Approved initial composition

Given valid detail, the initial viewport matches the approved cover-led order, Sage and Paper tokens, primary Add action, local helper, and About continuation without main navigation or capture controls.

### AC-02 — Collapsing header

When the body Add action fully leaves the viewport, the pinned Back/cover/title/author/Add header appears without showing two Add actions; scrolling back reverses it. Reduced motion uses an immediate state switch.

### AC-03 — Metadata fidelity

Given partial or inconsistent provider data, valid values render in the defined precedence/order and invalid or absent values are omitted without inference, fake labels, broken separators, or provider types crossing the adapter.

### AC-04 — Related catalog books

Given validated subjects, at most 10 unique provider-related books render in the approved accessible shelf, excluding the current identity. No personal data influences request or order. Empty/failure leaves detail usable.

### AC-05 — Navigation restoration

Opening from Browse, Weekly, Search, or another detail and pressing visible/system Back restores the exact prior route state and focus when available.

### AC-06 — Cache bounds and LRU

After opening more than five full details, exactly the five most recently accessed valid entries remain. Related summaries do not increase that count, and eviction changes no Discover cache or PersonalBook data.

### AC-07 — Offline behavior

Offline with cache renders and labels the cached page. Offline without cache explains that detail needs a connection and exposes Retry, Back, and manual creation without blocking local features.

### AC-08 — Refresh and failure isolation

Stale cached content remains visible during refresh. Timeout, rate limit, provider, malformed, related, image, or cache-write failure preserves every still-valid part and offers only relevant recovery.

### AC-09 — Add integration

Saving cannot be double-submitted. Failure is recoverable in place. Success produces one permanent local snapshot and a Saved state; catalog eviction cannot remove it. Navigation follows the staged PersonalBook Detail rule.

### AC-10 — Accessibility and localization

English LTR, Persian RTL, mixed-direction content, largest text, TalkBack, Switch Access, keyboard use, safe areas, and reduced motion preserve identity, actions, logical focus, contrast, and 48dp targets.

### AC-11 — Performance and restoration

The defined p95 budgets pass in profile/release mode, scroll remains smooth, async geometry does not visibly jump, and route/page state restores after process recreation.

### AC-12 — Privacy and boundaries

No title, author, description, subject query, ISBN, provider payload, or personal content enters production logs; opening a page writes only disposable cache/recency and never creates personal domain records.

## 13. Verification and completion gate

Required automated evidence:

| Layer | Coverage |
|---|---|
| Pure unit | Identity validation, field precedence, description normalization, subject query bounds, deduplication, representative-edition selection, LRU eviction. |
| Application/Riverpod | Cache-first loading, stale refresh, request identity, independent related failure, retry, import states, restoration, disposal. |
| Adapter contract | Edition/work/author/search fixtures, partial/malformed/oversize responses, typed failures, request limits, no sensitive logging. |
| Drift/cache | Schema/migration, atomic writes, five-entry LRU, read-recency, corrupt entry, restart, isolation from summary cache and PersonalBooks. |
| Widget/golden | Approved hero and scrolled states; loading/offline/error/missing fields/cover; English/Persian, large text, landscape/tablet, reduced motion, semantics/focus. |
| Integration | Browse/Search/Weekly → detail → Back, related → detail → Back, process restoration, offline cache, refresh, and import-contract handoff. |
| Performance | Cached open, network-to-render, scrolling, image loading, and duplicate-request scenarios with p50/p95 evidence. |

The feature is complete only when:

- AC-01 through AC-12 pass;
- both approved reference screens are matched within accessibility/adaptive constraints;
- full-detail cache never exceeds five entries and cannot affect personal data;
- all state, English/Persian, accessibility, restoration, offline, and failure tests pass;
- formatting, generated code verification, strict analysis, migrations, and relevant tests pass CI;
- ordinary tests use checked-in Open Library fixtures rather than live requests; and
- no new dependency or ADR is added unless implementation reveals a separately approved need.

## 14. Risks and dependencies

| Risk | Required mitigation |
|---|---|
| Open Library work/edition inconsistency | Explicit precedence, validation, partial rendering, checked-in contract fixtures. |
| Related results appear personalized | Label `Related catalog books`; use only bounded provider subjects and provider order. |
| Duplicate Add actions during collapse | One visibility threshold and widget test asserting only one actionable Add in the viewport. |
| Header clips in Persian/large text | Adaptive header height/two-row layout and golden/accessibility tests. |
| Disposable cache confused with Library | Separate models, storage, ownership language, and eviction-isolation tests. |
| Provider outage blocks local work | Cache/manual-create fallback; no dependency from PersonalBook or capture modules. |

Dependencies are the completed Discover/catalog foundation, shared theme/localization/routing, Riverpod, Drift migration harness, injected HTTP client/contact configuration, and the separately specified import use case. No new third-party package or ADR is required.
