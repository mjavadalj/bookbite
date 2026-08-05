# AGENTS.md

## Goal

Build BookBite from approved specifications. Prefer the smallest clear solution that protects reading flow, offline use, privacy, accessibility, and user data.

## Workflow

1. Read the relevant core docs in `docs/`, plus `app-navigation.md`, `roadmap.md`, the feature spec, and approved designs. The seven core specs named in `constitution.md` are peer authorities.
2. Confirm the work belongs to the current milestone and its feature spec is approved. `Proposed` is not approved.
3. Identify the scope, invariants, states, acceptance criteria, and completion gate before coding.
4. Resolve conflicting or missing requirements with the product owner; never guess. Change behavior in the spec first.
5. Implement the smallest vertical slice that satisfies the approved criteria.
6. Map tests to acceptance criteria. Update roadmap status only after verification passes.

## Engineering Rules

- Use feature-first Clean Architecture: `presentation -> application -> domain`; `data` implements inward-facing interfaces.
- Keep domain code pure Dart. Do not leak Flutter, Riverpod, Drift, HTTP, catalog, OCR, speech, or platform types into it.
- Keep local data as the source of truth; network access only enhances catalog discovery.
- Preserve data across failure, cancellation, restart, migration, and background processing; never silently reset or delete user data.
- Keep external/native services replaceable and validate their data at adapter boundaries.
- Use the approved stack and shared Sage and Paper tokens. Do not add dependencies or speculative infrastructure without a documented, approved need.
- Localize every user-facing string. Treat English LTR, Persian RTL, accessibility, large text, and reduced motion as required behavior.
- Keep logs free of extracted text, queries, source media, provider payloads, and sensitive personal metadata.
- Do not implement deferred features, cloud services, accounts, analytics, social mechanics, or alternate themes without an approved spec.

## Verification

- Cover relevant success, empty, loading, offline, error, retry, restoration, and data-preservation paths.
- Add focused unit, Riverpod state, widget, repository/migration, adapter-contract, and integration tests as required by the feature spec.
- Run formatting, code generation verification, strict analysis, and relevant tests before declaring work complete.
- Use checked-in fakes/fixtures in normal tests; do not depend on live Open Library.
- A task is done only when its acceptance criteria, completion gate, and applicable roadmap checks pass.
- Preserve unrelated user changes and avoid broad refactors unless the approved work requires them.
