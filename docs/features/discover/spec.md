# Feature Specification: Discover

**Status:** Proposed; implementation-ready pending product approval

**Feature owner:** Discover

**MVP platform:** Android, preserving future iOS compatibility

**Last updated:** 2026-08-01

## 1. Purpose and outcome

Discover helps a reader identify a physical book through an external catalog before continuing to `CatalogBook` overview or manual `PersonalBook` creation.

The feature must:

- make browsing and title, author, or ISBN search fast and understandable;
- help the reader distinguish available editions without inventing metadata;
- preserve browse or search context after child navigation;
- provide manual creation whenever the catalog cannot complete the task; and
- isolate all catalog delay and failure from local BookBite data and workflows.

Discover is a calm identification tool, not a recommendation or engagement feed. It must not use personalized ranking, popularity pressure, ratings, social proof, urgency, or reward mechanics.

## 2. Authority, scope, and boundaries

This specification adds feature-level detail under:

- `docs/vision.md`;
- `docs/constitution.md`;
- `docs/mvp-scope.md`;
- `docs/architecture.md`;
- `docs/domain-model.md`;
- `docs/tech-stack.md`;
- `docs/design-system.md`;
- `docs/app-navigation.md`;
- `docs/design/catalog-flow/catalog-flow-ux.md` and its approved MVP screens; and
- the Discover milestone in `docs/roadmap.md`.

If this specification conflicts with a governing document, implementation is blocked until the product owner resolves the conflict.

### 2.1 In scope

- Discover root and dedicated Active Search route;
- an `All` discovery feed and visible future-category previews;
- `Explore this week` shelf;
- adaptive Browse catalog grid/list;
- category and Filter preview feedback;
- title, author, and ISBN search;
- predictive pagination in 20-result batches;
- bounded catalog-summary, result-set, and thumbnail caching;
- offline search over cached summaries;
- all loading, empty, failure, offline, malformed-data, and recovery states;
- route contracts to `CatalogBook` overview and manual creation;
- navigation and process restoration;
- English LTR, Persian RTL, accessibility, and reduced motion;
- replaceable Open Library adapter behavior; and
- measurable quality and test criteria.

### 2.2 Out of scope

- `CatalogBook` overview UI, full metadata, related books, or full-detail cache;
- importing or persisting a `PersonalBook`;
- manual-creation form behavior;
- Library or `PersonalBook` detail behavior;
- Photo or Voice behavior beyond their global placement on the Discover root;
- personalized recommendations;
- reviews, ratings, availability, previews, prices, purchase links, or social data;
- barcode scanning, suggestions, recent searches, or saved searches;
- functional category switching and catalog filter/sort controls;
- accounts, backend services, synchronization, analytics, or remote logging; and
- theme selection or the post-MVP Ember and Ink theme.

Linked features require separate specifications. Discover defines only the data passed to them and the state restored on return.

## 3. Fixed product decisions and terminology

### 3.1 Fixed decisions

1. Discover root and Active Search form one feature and delivery unit.
2. `All` is the only functional MVP category.
3. `Philosophy`, `Fiction`, `History`, `Biography`, and `Self-help` remain visible as future-category previews.
4. `Explore this week` is provider-derived and non-personalized.
5. Future-category and Filter previews retain the approved composition; activation shows calm localized availability feedback and changes no results.
6. Browse and search collections request 20 items initially and 20 per next batch.
7. Next batches load automatically before the reader reaches the end.
8. Active Search uses a 400 ms debounce.
9. Manual `PersonalBook` creation is always reachable after search begins and is prominent when the catalog is unavailable or has no match.
10. This feature caches summaries and thumbnails only; full `CatalogBook` detail caching belongs to its own feature.

### 3.2 Terms

| Term | Meaning |
|---|---|
| `CatalogBook` | Validated external metadata with provider identity. It owns no personal data. |
| `PersonalBook` | Reader-owned local book record. Discover never creates one directly. |
| Discover root | Browse-mode root of the Discover destination. |
| Active Search | Focused full-screen search child route. |
| Catalog summary | Validated subset of `CatalogBook` metadata needed for a result. |
| Result set | Ordered catalog-summary identities for one request state. |
| Fresh cache | Valid cache within its freshness interval. |
| Stale cache | Valid cache outside that interval; it may remain visible during refresh. |

Code, tests, and documentation must use the canonical terms from `domain-model.md`. The catalog must never be labeled as the reader's `Library`.

## 4. Routes and navigation

### 4.1 Owned routes

| Route contract | Parameters | Presentation |
|---|---|---|
| Discover root | None | Main-destination root inside the navigation shell |
| Active Search | Optional initial query | Full-screen child above the preserved root |

Generated route class names follow project conventions. Both routes must use typed `go_router` contracts and restoration identifiers.

### 4.2 Entry, exit, and back

- First entry opens the root. Returning to Discover restores its retained stack.
- Reselecting Discover while on a child route returns to the root; reselecting it at the root scrolls to the top.
- Library's Add entry opens Active Search with an empty, focused field.
- An initial query from a valid route follows the same normalization and validation as typed input.
- Tapping the root search control opens Active Search; the root control is not editable.
- Cancel or system Back from Active Search restores the root exactly.
- Keyboard dismissal does not dismiss Active Search.
- Leaving browse or search requires no confirmation because it changes no personal data.

### 4.3 Outbound contracts

| Destination | Trigger | Data passed | On return |
|---|---|---|---|
| `CatalogBook` overview | Activate a valid result | Provider, selected edition/book identity, optional work identity, origin (`browse`, `weekly`, or `search`) | Restore originating collection, position, and focus. |
| Manual creation | Activate manual-create entry | Origin and optional trimmed query seed plus detected kind (`text` or `isbn`) | Restore Discover if canceled. |
| Photo or Voice | Activate global action on root | Current navigation context | Global capture contract applies; restore Discover. |

Activating a result must not import it or write any `PersonalBook`, `ReadingCycle`, `ReadingSession`, or `Bite` data.

## 5. Discover root

The root uses one vertical scroll surface in this order:

1. localized `Discover` heading;
2. search control labeled for title, author, or ISBN;
3. horizontal category rail;
4. `Explore this week` heading and horizontal shelf when usable;
5. `Browse catalog` heading and Filter action;
6. adaptive result grid/list;
7. inline pagination/end state; and
8. bottom inset for equal Photo and Voice actions above the five-destination navigation.

Root behavior:

- render valid cache immediately and refresh stale content without clearing it;
- load the weekly shelf and Browse collection independently;
- preserve one section when the other fails;
- keep horizontal gestures limited to the category and weekly rails;
- open result overview on activation; and
- preserve the reader's visible anchor when content identities remain available.

## 6. Category previews and weekly exploration

### 6.1 Category rail

| Stable key | English label | Provider concept |
|---|---|---|
| `all` | All | Configured discovery-subject pool |
| `philosophy` | Philosophy | Philosophy subject |
| `fiction` | Fiction | Fiction subject |
| `history` | History | History subject |
| `biography` | Biography | Biography subject |
| `selfHelp` | Self-help | Self-help subject |

Labels are localized; provider slugs remain inside the adapter. The five subject concepts form the initial configurable discovery pool used by the `All` Browse feed.

- `All` is always selected and is the only chip that controls results in the MVP.
- Activating `All` again is a no-op.
- The other chips retain the approved visual treatment. Activating one shows calm localized feedback equivalent to `More categories are coming later`, changes no state, and makes no request.
- Preview-chip semantics must include the label and future availability; feedback is announced politely.
- Preserve the category rail position across child navigation.
- When space permits, a partially visible final chip may indicate overflow, but next/previous semantic scrolling is required.

### 6.2 Explore this week

- For `All`, use Open Library's weekly-trending collection and display at most 10 unique valid summaries.
- Fewer than 10 valid results render without blank slots.
- No valid weekly content omits both shelf and heading without making the Browse collection empty.
- The shelf does not paginate beyond 10 items.
- Personal Library or ReadingJourney data must never affect membership or order.
- Valid cached weekly content remains usable when live content is unavailable and must be labeled as cached/offline when appropriate.

## 7. Filter preview

Filter retains its approved placement and visual treatment but does not filter or sort in the MVP. Activating it shows calm localized feedback equivalent to `Filters are coming later`, changes no state, and makes no request. Its accessible name includes its future availability and the feedback is announced politely.

## 8. Active Search

### 8.1 Surface behavior

- Active Search initially focuses an editable field with platform Search action.
- A visible Cancel action is always present.
- Clear is shown only for non-empty input. It cancels or invalidates pending work, clears results, returns to the pre-search state, and keeps field focus.
- Main navigation and Photo/Voice are absent on this focused route.
- Before a query, show brief title/author/ISBN guidance and a low-emphasis manual-create entry. Do not show fake suggestions, trending content, or recent searches.

### 8.2 Query rules

- Keep the visible editing value unchanged; for request/cache identity, trim outer Unicode whitespace and collapse internal whitespace.
- Remove non-whitespace control characters from the request value. If nothing remains, make no request.
- Support Unicode title/author text, Persian and Latin digits, ISBN-10, and ISBN-13.
- For ISBN detection only, convert Persian digits, remove spaces/hyphens, and normalize terminal `x` to `X`.
- Treat 10 characters with nine digits plus a digit or `X`, or 13 digits, as ISBN-like. Checksum failure must not prevent lookup.
- Reject normalized input over 200 Unicode scalar values with a localized field error and no request.
- Empty input makes no request.
- At three or more grapheme clusters, search automatically 400 ms after the last edit.
- One- or two-grapheme text shows guidance to type another character and makes no request, including on explicit submit.
- A complete ISBN-like query follows the same debounce or submits immediately.
- Explicit submit bypasses the remaining debounce for a valid text or complete ISBN query and dismisses the keyboard.
- Older requests must be canceled where possible and always rejected if their identity/generation no longer matches.
- Repeating a fresh normalized query uses cache and must not create a duplicate simultaneous request.

### 8.3 Result replacement

- During debounce or first load for a changed query, keep prior-query results visible and usable.
- Clearly label those results with their submitted query and separately indicate the pending query.
- Replace them only when valid cache or a valid response for the new query is selected.
- Never relabel old results as matches for new input.
- Reset the new collection to its leading edge when selected.
- Show a trustworthy provider count when available; otherwise use `Catalog results` without inventing a count.
- Search results use one vertical list and show manual creation after the first batch or immediately in no-result/unavailable/offline-without-match states.

### 8.4 Match emphasis

- Emphasize a visible title/author match with weight and underline; color alone is insufficient.
- Compare case-insensitively with Unicode normalization. Persian matching ignores optional diacritics and tatweel without changing displayed text.
- If normalized positions cannot map safely to displayed graphemes, emphasize the whole matched field.
- ISBN matches show the identifier as metadata.
- Accessible names read natural title/author text once and exclude emphasis markup.

## 9. Catalog summaries and result display

### 9.1 Valid identity and mapping

A result is valid only with a recognized provider namespace, a syntactically valid provider book/edition/work identity, and a non-blank title.

For Open Library search records, select identity deterministically:

1. best matching valid `editions.docs[].key`;
2. otherwise first valid `edition_key`;
3. otherwise valid work `key`.

Retain the work identity when an edition is selected. An item's selected identity must remain stable for cache, deduplication, navigation, and refresh.

Optional mapped fields may include authors, edition label, language, first-publication year, ISBNs, cover reference, work identity, and provenance. Selected-edition values take precedence only when they belong to that edition. Missing metadata remains absent; BookBite must not infer, translate, or correct it.

### 9.2 Deduplication and display

- Deduplicate by provider plus selected edition/book identity, falling back to work identity only when no edition identity exists.
- Preserve first occurrence and provider order, including across appended pages.
- Do not merge distinct editions because title and author happen to match.
- Title is always visible and wraps within adaptive limits.
- Join multiple authors with locale-aware formatting; absent authors use localized `Author unavailable` treatment.
- Omit empty metadata labels and separators.
- Missing/failed covers use a stable 2:3 placeholder and never disable the result.
- Each result has one clear activation action and is identifiable without cover art.

## 10. Predictive pagination

- Initial and subsequent requests ask for 20 results.
- Prefetch the next batch when the reader is within two estimated viewport heights of the rendered end or no more than eight loaded items remain after the last visible item, whichever occurs first.
- Allow one next-page request per result-set identity; coalesce repeated scroll triggers.
- Append only if the result-set identity and continuation still match.
- Preserve existing order, stable keys, focus, and scroll offset.
- Stop when the provider reports no continuation, returns no records, or two consecutive non-empty pages yield no new valid identity after validation/deduplication.
- Do not show pagination UI if prefetch completes before the reader reaches the end.
- If the end is reached while loading has lasted over 250 ms, show a reserved inline loader/static skeleton without covering content.
- On failure, retain all loaded results and show inline Retry from the last confirmed continuation.
- Show a low-emphasis end message only when the reader reaches the end.
- Whenever more is available, expose a semantic `Load 20 more books` action as a non-gesture alternative. It coalesces with automatic loading.
- Lazily build off-screen items and covers; predictive data loading must not eagerly build the full collection.

## 11. States and recovery

Weekly, Browse, search first-page, and pagination state must be independent. A whole-page `isLoading`/`hasError` flag is insufficient.

| State | Required presentation and recovery |
|---|---|
| Initial, no cache | Keep structure/actions usable; show stable section skeletons only after 300 ms; replace sections independently. |
| Fresh cache | Render immediately with no blocking indicator. |
| Stale cache, online | Keep content usable with subtle updating state; replace only with a valid refresh; preserve it on failure. |
| Populated | Render valid results and continue predictive pagination while more exists. |
| Browse empty | Explain that no books are currently available; offer search and manual creation. |
| Search empty | Before input show guidance; after a valid response show query-specific no-match copy and primary manual creation. |
| Offline with cache | Label content as saved/offline catalog information and show last update when known. |
| Offline without cache | Explain that live catalog use needs a connection; keep manual creation, Retry, and local/global navigation available. Never say `No results`. |
| Provider unavailable/timeout | Preserve cache or loaded results; explain temporary unavailability and offer Retry plus manual creation. |
| Rate limited | Preserve content; honor `Retry-After`/backoff and disable Retry until safe without using a pressure countdown. |
| Partial malformed response | Show valid records in order and omit invalid records without an alarming page error. |
| Entire response malformed | Show recoverable invalid-response state, not empty/no-results; preserve prior cache. |
| Missing metadata/cover | Use field-level fallback; the result remains actionable. |
| Cache member missing | Omit only that item, repair disposable membership, and retain remaining content. |
| Cache read/write failure | On read failure, attempt network when available; on write failure, keep current in-memory results. Disclose lost offline availability only when relevant, and never affect personal data. |
| Pagination loading/failure/end | Keep loaded results; use inline loader, Retry, or end message respectively. |

Additional rules:

- Connectivity signals are hints; actual requests remain authoritative.
- Losing connectivity never clears valid data.
- After connectivity returns, refresh the unchanged active first page once and deduplicate it with explicit Retry.
- Failed pagination remains on its inline Retry path until reader Retry or a new threshold crossing.
- Offline, timeout, provider failure, or invalid records must never be represented as no results.
- Every failure must state what is unavailable and what the reader can do next, without status codes, stack traces, blame, or provider jargon.

## 12. Local cache and offline search

Catalog cache is disposable external data. It remains separate from permanent `PersonalBook` snapshots and all personal reading data.

### 12.1 Stored data and identity

Store validated summaries, ordered result-set snapshots/membership, continuation, freshness/access timestamps, and optional app-private thumbnails.

A result-set identity includes provider, feed type, normalized query when applicable, discovery-pool version for Browse, current result-language preference, page size, and adapter schema version. Continuation is stored on the snapshot, not in the base identity.

Persist timestamps as UTC instants from an injected clock. Search query keys stay on device, are sent only to the catalog provider for that search, and are excluded from diagnostics.

### 12.2 Bounds and freshness

| Bound | Limit |
|---|---:|
| Distinct catalog summaries | 500 |
| Result-set snapshots | 40 |
| Persisted ordered identities per set | First 100 |
| Cover-thumbnail cache | 50 MiB |

| Data | Fresh for |
|---|---:|
| Weekly result set | 6 hours |
| Browse/search result set | 24 hours |
| Catalog summary | 7 days |
| Cover thumbnail | 30 days, or stricter provider cache headers |

- Expired data may remain an offline fallback until eviction.
- Delete inactive search query/result keys and browse/weekly snapshots after 30 days.
- Delete unreferenced summaries/thumbnails after 90 days.
- Enforce numeric limits with least-recently-accessed eviction after successful writes.
- Remove result membership before an unreferenced summary.
- Cleanup failure must not fail a successful read; retry later.
- Missing thumbnail files clear their index and use the placeholder.
- Cache eviction or migration must never delete/reset a `PersonalBook`, personal history, Bite, or source media.

### 12.3 Offline local search

When live search cannot run or fails, search cached title, author, and ISBN fields:

1. exact ISBN;
2. exact normalized title;
3. title prefix;
4. title substring;
5. author substring.

Break ties by most-recent access then provider identity. Return at most 100 matches in 20-item pages, apply normal validation/deduplication, and label them as saved catalog information rather than the Library. No full-text-search dependency is required.

## 13. External catalog contract

### 13.1 Provider-neutral repository

The application requires provider-neutral operations for weekly, Browse, live search, and cached search. Each page returns:

- validated summaries;
- an opaque continuation and whether end is known;
- source (`network`, `freshCache`, `staleCache`, or `offlineCache`);
- last successful refresh when known; and
- a total only when the provider marks it trustworthy and BookBite has not filtered locally.

Read policies must distinguish:

- `cacheFirst`: return valid cache once; the application explicitly requests refresh when stale;
- `networkWithCacheFallback`: prefer network, then return valid cache for typed network failure; and
- `cacheOnly`: never access network.

Widgets and the application layer must not depend on Open Library URLs, JSON names, HTTP codes, offsets, or cover URL construction.

### 13.2 Open Library mapping

| Operation | Request behavior |
|---|---|
| Weekly, `All` | `GET /trending/weekly.json`; request 10 candidates. |
| Browse, `All` | `GET /search.json` with an `OR` query over the configured discovery-subject pool, `sort=trending`, selected fields, `limit=20`, and offset pagination. |
| Active Search, text | Search API with escaped literal query, selected work/edition fields, current `lang`, `limit=20`, and offset pagination. |
| Active Search, ISBN | Search API with an `isbn:` clause containing normalized ISBN characters and the same fields/language/pagination. |

The initial discovery-subject keys are `philosophy`, `fiction`, `history`, `biography`, and `self_help`. They are adapter configuration rather than UI state; future releases may revise the pool with a specification update.

Use `lang=en` for English and `lang=fa` for Persian where supported. It influences edition ranking and must not be treated as an exclusion filter. Offset advances by raw provider records consumed, not records remaining after validation.

### 13.3 Adapter and request rules

The adapter must:

- use HTTPS APIs and never scrape HTML;
- request only required summary fields;
- encode parameters through the HTTP client and escape reader text as a literal query;
- validate/map boundary DTOs before creating `CatalogBook` values;
- send an identifying `User-Agent` containing BookBite and the approved contact, plus any separate email identification required by current provider guidance;
- limit identified metadata traffic to at most three requests per second, or stricter current guidance;
- allow at most two simultaneous metadata requests;
- honor `Retry-After`;
- use a 10-second total timeout;
- retry an idempotent metadata request at most once, only for transient connection/server failure, with randomized 500-1,500 ms backoff;
- support cancellation or stale-response rejection;
- expose typed offline, timeout, rate-limited, unavailable, invalid-response, cache, and unexpected failures; and
- apply stricter provider cache headers.

Before implementation, re-check the current provider documentation linked in section 22. Compatible adapter details may change without altering visible product behavior. Discovery-pool meaning, ordering, batch size, privacy, or ownership require a spec update.

### 13.4 Untrusted data and covers

- Reject a metadata body over 2 MiB before JSON decoding and inspect no more than 200 records from one response.
- Bound collection and string fields, validate identifiers/numeric ranges, strip disallowed control characters, and render all metadata as plain text.
- Invalid optional fields are omitted; invalid required identity/title rejects the record. A response-level violation produces `invalidResponse`.
- Construct HTTPS cover URLs only inside the adapter and request the size needed for rendered bounds/device density.
- Allow at most four simultaneous cover downloads; prefetch at most two viewports or 12 covers beyond visibility, whichever is smaller.
- Reject a cover body over 5 MiB or unsupported/invalid image data.
- Store thumbnails only in app-private cache and use the shared placeholder on any cover failure.

The product owner must approve the catalog contact address before production traffic. It is deployment configuration, not a secret, and must not be invented by an implementer.

## 14. Architecture and persistence

Discover follows feature-first Clean Architecture:

```text
Presentation -> Application -> Domain contracts
                    ^
                    |
          Open Library + Drift/file cache adapters
```

- Presentation owns layout, focus, semantics, localization, route state, and feedback.
- Application owns debounce, cache policy, request coordination, stale guards, pagination, and state transitions.
- Domain owns canonical `CatalogBook` identity/invariants and remains pure Dart.
- Data owns provider DTOs, HTTP behavior, validation, mapping, Drift cache tables, and thumbnail files.
- Riverpod exposes state but must not contain provider or persistence rules.
- Discover must not read personal storage to rank or reorder catalog content.

No personal domain entity is added. Discovery-pool configuration, page, and load state are feature/application values.

Drift persistence must represent summaries, result sets, and ordered membership with provider identity, request identity, continuation, freshness, and access timestamps. Writes/replacements are transactional; migrations are versioned/tested. Failure exposes recoverable catalog unavailability and must never reset the database or damage personal tables.

## 15. Visual and interaction requirements

The approved catalog-flow screens and Sage and Paper design system control composition. Feature code uses shared semantic tokens; it must not duplicate token values locally or activate an unapproved dark theme.

- Use the 8dp grid, adaptive gutters, 48x48dp minimum targets, and 8dp separation between adjacent targets.
- Prefer whitespace and hairline dividers over many elevated cards.
- Reserve safe-area and global navigation/capture insets; fixed UI must not obscure content or focus.
- Use shared vector icons. Do not use emoji icons, gradients, glow, glass blur, strong texture, large shadows, parallax, or decorative entrance sequences.
- Every activation gives pressed feedback within 100 ms without layout shift.
- Repeated async activation coalesces; disabled controls are visibly and semantically disabled.
- Ordinary browse or search actions do not show success toasts. Preview controls use only their localized availability feedback.

### 15.1 Adaptive results

- Browse uses the greatest column count that keeps a tile at least 104dp wide after gutters/gaps.
- Typical phones show three columns; narrow widths or large text reduce columns.
- Switch to the one-column search result pattern when two columns cannot show title, author, and a 48dp target without overlap.
- Tablets may add columns but cap readable content width.
- Covers reserve a 2:3 ratio. Grid titles may wrap to three lines; essential identity must not be one-line clipped.
- Changing size/orientation/text scale preserves the stable first-visible identity as close as possible to its prior leading position.

### 15.2 Motion

- Use shared 150-300 ms motion for route, sheet, and micro-interaction transitions.
- Refresh may crossfade without moving scroll; appended tiles do not animate individually.
- With reduced motion, use platform reduced transitions, static skeletons, and no cover interpolation or animated reordering.
- Motion never controls meaning, focus, or availability.

## 16. Accessibility, localization, and RTL

- Expose one page heading and sequential section headings.
- Controls announce name, role, state, and value; `All` announces selection and preview controls announce future availability.
- Each result is one coherent actionable semantic node/group whose name includes title, author and displayed edition/language when available, plus its open action.
- Decorative covers/dividers are excluded from semantics; no icon-only action is unlabeled.
- Focus order follows reading order. Opening search focuses its field; Clear returns focus there.
- Result updates use polite announcements and never steal focus. Pagination announces newly added count once and preserves focus.
- Returning from overview focuses the originating result or, if absent, the collection heading.
- All behavior works with TalkBack, Switch Access, hardware keyboard, standard Back/Escape, and non-swipe rail/pagination alternatives.
- Meet WCAG 2.2 AA contrast: 4.5:1 normal text and 3:1 large text/essential graphics.
- Do not rely only on color, imagery, orientation, or animation.
- Support the largest platform text setting without hiding essential content/actions or causing page-level horizontal scrolling.

All visible strings, semantics, errors, numbers, counts, category labels, and preview messages use `gen_l10n`/ARB resources. English LTR and Persian RTL receive equal coverage.

RTL mirrors alignment, rails, focus order, and directional icons/transitions where appropriate. The approved five-destination order is not independently reversed by this feature. Titles, authors, and ISBNs are directionally isolated and render in their natural direction. Localized digits are accepted in search; provider keys remain locale-independent.

Changing app language preserves controls, query, and anchors, then selects the result-set identity for the new language preference. Prior-language results may remain only as clearly labeled updating content.

## 17. Privacy and security

- Send only the catalog query and necessary discovery-pool/language parameters to Open Library.
- Never send personal Library, ReadingJourney, Bite, source media, device identity, or precise location data.
- Exclude queries, provider payloads, and personal content from production logs, analytics, crash payloads, and remote diagnostics.
- The MVP introduces no analytics, remote crash SDK, authentication, backend, or authorization surface.
- Treat provider data as untrusted and enforce section 13 validation at the Data boundary.
- Accept only trusted HTTPS cover URLs; provider content cannot create HTML, rich text, deep links, or executable markup.
- Keep catalog rows and cover files in app-private storage.
- Disposable cache deletion must never cascade into permanent `PersonalBook` snapshots or personal history.

## 18. Performance and reliability

Measure release/profile builds on the product-approved minimum Android device. Device approval is an application-foundation release gate.

| Measure | Target |
|---|---:|
| Pressed feedback | <=100 ms at p95 |
| Root scaffold/controls from warm app | <=500 ms at p95 |
| Cached first content after route state | <=300 ms at p95 |
| Search request after last eligible edit | 400 ms +/-75 ms |
| Accepted response to first 20 rendered | <=300 ms at p95, excluding network |
| Pagination append after acceptance | <=250 ms at p95 without offset change |
| Scroll rendering | 60 fps target; p95 build+raster <=16.7 ms on reference device |
| Metadata timeout | 10 seconds |

- Network, non-trivial parsing, cache cleanup, and image decoding must not block the UI isolate.
- Use lazy Flutter slivers/builders with stable keys and reserved cover geometry.
- Do not issue duplicate first/next-page requests or preload more than the next 20 metadata results.
- Background work must not block navigation, scrolling, editing, capture entry, or other destinations.
- Interrupted cache writes expose either the prior valid snapshot or the complete new one, never partial ordered membership.

## 19. Restoration and lifecycle

Within the retained Discover stack, preserve:

- root versus Active Search route;
- category-rail offset;
- visible input and last submitted normalized query;
- cached loaded identities/continuation;
- vertical and horizontal anchors/offsets; and
- focused result identity when still present.

On destination return, reopen the software keyboard only if the search field held focus; never reopen it when focus was in results.

Process restoration stores compact route/control/query (maximum 200 characters), result-set key, and stable anchor data—not full provider responses. Rehydrate from cache and refresh by freshness. In-flight requests need not survive process death.

- Restart only the active stale/absent first page.
- Resume pagination only if the restored reader position remains inside the threshold and continuation is valid.
- If cache was evicted, restore controls/query at collection start and load again.
- Invalid/missing restored identities return to the nearest valid Discover surface without clearing other data.

## 20. Acceptance criteria

### AC-01: First online browse

**Given** no cache and an available network, **when** Discover opens, **then** root controls appear independently of catalog requests, `All` is selected, weekly and Browse load independently, Browse requests 20 summaries, and no personal record is written.

### AC-02: Preview controls and weekly truthfulness

**Given** identical provider data but arbitrary personal Library/history data, **when** Discover loads, **then** weekly ordering is identical for every reader and contains at most 10 unique valid results. Activating a future-category chip shows localized availability feedback without changing results or making a request.

### AC-03: Filter preview

**Given** the Discover root, **when** Filter is activated, **then** localized availability feedback is shown/announced, no sheet opens, results and position remain unchanged, and no request occurs.

### AC-04: Debounced and explicit search

**Given** Active Search, **when** input changes before 400 ms, **then** only the latest eligible query of at least three graphemes begins after 400 ms +/-75 ms and older responses cannot replace it. One- or two-grapheme text makes no request and shows guidance even on explicit submit.

### AC-05: Search replacement and clear

**Given** prior-query results and a changed input, **when** the new query is debouncing/loading, **then** old results remain correctly labeled and usable until valid new results are selected. **When** Clear is activated, **then** input/results clear, pending work becomes stale, focus stays in the field, and late responses cannot repopulate it.

### AC-06: No results and manual creation

**Given** a valid successful search with no matches, **when** it completes, **then** the UI names the query, does not imply failure, and makes manual creation primary. Manual creation is also reachable after a populated first batch.

### AC-07: Result identity and activation

**Given** duplicate, distinct-edition, missing-author, and missing-cover records, **when** mapping/rendering occurs, **then** duplicates are removed by stable identity, distinct editions remain separate, fallbacks preserve geometry/semantics, and activation passes identity to overview without importing.

### AC-08: Predictive pagination success

**Given** 20 loaded results and continuation, **when** either threshold is reached, **then** exactly one next-20 request starts. A valid response appends unique items without reordering, focus change, offset jump, or visible loader when it finishes early.

### AC-09: Pagination failure and end

**Given** loaded results, **when** the next page fails, **then** results remain usable and Retry resumes from the confirmed continuation. Two consecutive non-empty duplicate/invalid-only pages mark completion without a third automatic request.

### AC-10: Offline with and without cache

**Given** offline state, **when** matching cache exists, **then** saved catalog content is clearly labeled and usable. **When** it does not exist, **then** the UI explains that live search needs a connection, never says `No results`, and makes manual creation primary.

### AC-11: Malformed/provider failure isolation

**Given** mixed valid/invalid records, **then** valid records render in order and payload content is not logged. **Given** an all-invalid/unavailable response, **then** a recoverable error—not empty state—appears, prior cache remains, and local BookBite features/data remain usable.

### AC-12: Back and process restoration

**Given** a query or Browse collection with multiple pages and a visible/focused result, **when** overview is opened and closed or the app restores, **then** controls, cached identities, continuation, anchors, and focus restore when available without jumping to top.

### AC-13: Cache isolation and bounds

**Given** cache limits are exceeded and a `PersonalBook` snapshot shares catalog values, **when** cleanup runs, **then** disposable cache returns within bounds while the `PersonalBook` and all personal history remain unchanged.

### AC-14: Request coordination

**Given** rapid query/scroll changes and preview-control activations, **when** work is coordinated, **then** preview controls make no catalog request, shared rate/concurrency limits hold, duplicate identities coalesce, latest state wins, and `Retry-After` prevents early retry.

### AC-15: English, Persian, and mixed direction

**Given** Persian RTL with Persian titles, Latin ISBNs, and mixed-direction authors, **when** all Discover surfaces render, **then** layout/focus/icons mirror appropriately, metadata keeps natural direction, localized digits work, and provider keys remain stable.

### AC-16: Large text, assistive technology, and reduced motion

**Given** maximum text, TalkBack/Switch Access, or reduced motion, **when** the feature is used, **then** layouts adapt without hiding essential actions, rails and pagination have non-swipe alternatives, focus remains stable, skeletons do not shimmer, and no behavior depends on animation.

### AC-17: Global capture placement

**Given** the Discover root, **then** Photo and Voice have equal placement above main navigation. **Given** Active Search or overview, **then** they are absent; Cancel/Back restores the root and capture pair.

### AC-18: Performance

**Given** the approved reference device and profile/release build, **when** the defined browse, search, cache, and pagination scenarios run, **then** every budget in section 18 meets its p95 target and no duplicate metadata request occurs.

## 21. Verification and definition of done

### 21.1 Required automated evidence

| Test layer | Required coverage |
|---|---|
| Pure unit/value | Query normalization, ISBN detection, identity, deduplication, offline ranking, pagination coordination, bounds, validation |
| Application/Riverpod | Independent section states, cache/refresh, preview feedback, fake-clock debounce, stale responses, request coalescing, failures, connectivity, restoration |
| Adapter contract | Sanitized weekly/search fixtures, parameters/identification, work/edition mapping, pagination, malformed/oversize data, typed HTTP failures, retry/rate behavior, no sensitive logging |
| Drift/file cache | Schema/migrations, atomic replace/append, rollback, LRU/bounds/expiry, corrupt disposable data, restart, personal-data isolation |
| Widget/golden | Root/search state families and preview controls in English and Persian; adaptive layout, large text, safe insets, semantics/focus, missing metadata, reduced motion |
| Integration | Browse/search through overview and return, three pagination batches, destination/process restoration, offline/failure isolation, capture placement, accessible pagination |
| Performance | Section 18 scenarios with p50 and p95 recorded in the implementation PR |

Ordinary CI uses checked-in provider fixtures, not live Open Library. A separately tagged live smoke check may be used for release verification.

### 21.2 Done criteria

The feature is done only when:

- AC-01 through AC-18 pass;
- all states in section 11 have a recovery path and verified English/Persian presentation;
- approved Sage and Paper references are matched within adaptive/accessibility constraints;
- semantics, focus, maximum text, contrast, non-touch operation, and reduced motion pass;
- cache bounds, migrations, restart, offline behavior, and personal-data isolation pass;
- current Open Library identification/rate guidance and approved contact configuration are verified;
- section 18 budgets pass on the approved device;
- formatting, strict analysis, generated code, unit/widget, migration, and relevant integration checks pass CI;
- no Open Library/HTTP/Drift/Flutter type crosses a prohibited architecture boundary; and
- production diagnostics contain no query, provider payload, or personal content.

## 22. Dependencies, risks, and references

### 22.1 Required foundation

- Flutter/Dart bootstrap with strict analysis;
- Sage and Paper tokens/shared components;
- English/Persian localization;
- typed routing/restoration;
- Riverpod 3 wiring;
- Drift migration harness; and
- injected provider-neutral catalog repository, HTTP client, clock, connectivity hint, and app-private cache storage.

No new third-party package is required beyond the approved stack. Adding a cache, image, connectivity, search, analytics, or other package requires separate dependency review and demonstrated need.

Linked but separately specified features are `CatalogBook` overview, import, manual creation, Library/detail, and global capture. Discover may use typed route fakes until those targets exist; it must not absorb their requirements.

### 22.2 Material risks

| Risk | Required mitigation |
|---|---|
| Provider/schema drift | Replaceable adapter, validation, checked-in fixtures, typed failures, and manual creation fallback |
| Search race or duplicate pages | Request identity/generation, cancellation, coalescing, stable deduplication |
| Infinite-scroll waste/inaccessibility | One predictive 20-item batch, fixed threshold, bounds, Retry, semantic load-more action |
| Cache confused with Library | Explicit saved-catalog copy and separate disposable persistence |
| Cover/layout jank | Reserved geometry, sized/lazy requests, bounded concurrency/cache, placeholder |
| RTL/mixed metadata defects | Directional isolation and equal English/Persian verification |
| Catalog failure affecting local workflows | Module/repository isolation and failure-injection tests |

### 22.3 Provider references

- [Open Library API usage and rate limits](https://openlibrary.org/developers/api)
- [Open Library weekly trending](https://openlibrary.org/trending/weekly)
- [Open Library Search API](https://openlibrary.org/dev/docs/api/search)
- [Open Library Search syntax](https://openlibrary.org/search/howto)
- [Open Library Covers API](https://openlibrary.org/dev/docs/api/covers)
