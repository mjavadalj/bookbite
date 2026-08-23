# Technical Stack

## Purpose

This document records BookBite's approved engineering choices. Exact dependency versions are pinned in project configuration when the app is bootstrapped; this document records technologies and constraints.

## Platform

| Area | Decision | Constraint |
|---|---|---|
| Application framework | Flutter, current stable release at bootstrap | Pin the SDK; avoid unnecessary native UI |
| Language | Dart version bundled with the pinned Flutter SDK | Enable sound null safety and strict analysis |
| Primary platform | Android | Preserve compatibility with a future iOS implementation |
| Architecture | Feature-first Clean Architecture | Presentation, application, domain, and data layers |

The minimum Android API level and reference performance device require product approval before implementation.

## Application Stack

| Area | Decision | Constraint |
|---|---|---|
| State and dependency wiring | Riverpod 3 with code generation | Application/presentation only; domain remains independent |
| Local database | Drift over SQLite | Versioned schema and tested migrations |
| Routing | Generated typed `go_router` routes | Define restoration, deep links, and nested navigation explicitly |
| HTTP | Dart `http` Client | Inject clients and keep provider logic behind adapters |
| Catalog | Open Library | Free initial provider; cache results and keep replaceable |
| Camera | Official Flutter `camera` package | Access through an application-facing interface |
| Audio recording | Flutter `record` package | Record 16 kHz mono PCM WAV to app-private storage behind an interface |
| File locations | Official `path_provider` package | Use app-private storage |
| Localization | Flutter `gen_l10n`, ARB, and `intl` | English LTR and Persian RTL from the first feature |

Open Library requests must follow its identification, caching, and rate-limit guidance. Manual PersonalBook creation remains the required fallback.

## OCR

| Area | Decision | Constraint |
|---|---|---|
| Engine | Tesseract 5 | Free and fully on-device in MVP |
| Integration | Dart interface with isolated native Android/iOS adapters | No OCR framework types outside the data adapter |
| Models | Bundled English and Persian trained data | English is the primary release-quality target; Persian is secondary |
| Execution | Background processing | Must not block the UI; must resume or fail recoverably |

The MVP uses no cloud or paid OCR. Future cloud OCR requires a separate approved specification, explicit consent, and a replaceable adapter.

## Speech-to-Text

| Area | Decision | Constraint |
|---|---|---|
| Engine | `whisper.cpp` | Free, multilingual, and fully on-device in MVP |
| Integration | Dart interface with isolated native Android/iOS adapters | No engine types outside the data adapter |
| Model | Bundled multilingual Whisper Tiny Q5_1 with a five-second native audio context | Supports English and Persian without a runtime download; the shortened context prevents 30-second padding from causing multi-minute inference on 32-bit devices |
| Execution | Background processing after recording stops | Must not block the UI; must resume or fail recoverably |

The model variant must be pinned after English/Persian accuracy, package-size, memory, and latency testing on the approved minimum device. The MVP uses no cloud or paid speech-to-text.

## Storage

- Drift/SQLite stores structured domain and processing data.
- App-private files store retained source images and voice recordings.
- File references are managed through the database.
- Capture, cleanup, archive, deletion, and migration workflows must be tested.
- Encryption beyond operating-system app-private storage requires a separate product/security decision.

## Testing

Use:

- `flutter_test` for unit and widget tests;
- `integration_test` for end-to-end workflows;
- Riverpod `ProviderContainer` tests for application state;
- Drift repository and migration tests;
- selective golden tests for stable visual contracts;
- fakes before mocks where practical.

Tests must cover positive, negative, edge, offline, restart, recovery, accessibility, RTL, and data-preservation behavior appropriate to each feature.

Voice-capture tests must cover permission denial, Cancel, the 5-second automatic stop, durable audio retention, retry after restart, deletion, and English/Persian transcription.

ReadingSession tests must verify idle launch, explicit Start, automatic start on successful Photo or Voice capture, active-session reuse, Bite linkage, and no session creation after denied, canceled, or pre-capture failure paths.

## Quality and CI

Use:

- `dart format` in check mode;
- strict Dart analyzer settings;
- current Flutter lints;
- generated-code verification;
- dependency review;
- GitHub Actions.

CI must run formatting, analysis, unit/widget tests, database migration tests, and Android integration checks appropriate to the change.

Readable, maintainable, and testable code takes priority over premature optimization. Performance-critical work must be measured against targets defined by the relevant feature specification.

## Privacy and Diagnostics

The MVP uses privacy-safe local diagnostics only.

It includes no:

- backend;
- authentication;
- cloud storage or synchronization;
- cloud OCR;
- cloud speech-to-text;
- remote analytics SDK;
- remote crash-reporting SDK.

Logs must exclude extracted text, page images, voice recordings, and sensitive personal metadata.

## Specification-Driven Development

Every major capability requires an approved feature specification before implementation.

A feature specification must define:

- behavior and boundaries;
- domain impact;
- data flow and failure recovery;
- accessibility and localization;
- measurable performance and quality criteria;
- test coverage;
- any new dependency and its justification.

Product decisions drive technology decisions, not the reverse.
