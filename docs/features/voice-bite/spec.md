# Feature Specification: Voice Bite

**Status:** Approved
**Last updated:** 2026-08-22

## Purpose

Voice Bite lets a reader preserve a short spoken thought without leaving the book for long. Recording, source retention, transcription, editing, and retry are fully local.

## Fixed decisions

- Record 16 kHz mono PCM WAV in app-private storage.
- Show recording state and remaining time, with Stop and Cancel controls.
- Stop automatically at 5 seconds. Manual Stop may finish sooner.
- Cancel, permission denial, and failure before durable capture create no Bite or ReadingSession.
- Durable capture reuses the active ReadingSession or creates one at capture start.
- Store the recording, Bite, media reference, and persistent extraction job before confirming.
- Use bundled multilingual `whisper.cpp` tiny Q5_1 behind `SpeechToTextService` with automatic English/Persian detection and no translation. This model is required for acceptable latency and package size on the minimum 32-bit device.
- Keep recordings until explicitly deleted. Text remains editable and persists independently.

## States and recovery

The UI exposes recording, durable saving, queued, processing, ready, and recoverable failed states. An interrupted running job is requeued up to the bounded attempt limit, then becomes failed with Retry. Existing photo capture and personal data remain usable after microphone denial or transcription failure.

## Accessibility and localization

All text and semantics are localized in English and Persian. Controls are native buttons with at least 48dp targets, visible labels, logical focus order, safe-area clearance, and no color-only meaning. The remaining-time value uses stable tabular figures.

## Quality and performance gates

- The bundled model is `ggml-tiny-q5_1.bin`, 32,152,673 bytes, SHA-256 `818710568DA3CA15689E31A743197B520007872FF9576237BDA97BD1B469C3D7`.
- A transcription that exceeds 60 seconds is cancelled and becomes recoverably failed instead of remaining in `processing` indefinitely.
- The local `whisper_edge` fork limits the native encoder context to the five-second recording, uses one greedy segment, and disables repeated temperature fallbacks. On a Samsung SM-A025F (`armeabi-v7a`), a five-second silence smoke test loaded the model in 1.334 seconds and completed native transcription in 21.479 seconds. This fixes the multi-minute stall but does not satisfy the <= 5-second p95 release target, so the performance gate remains open.
- Record English and Persian word error rate, model-load time, transcription p50/p95, peak memory, installed size, and thermal behavior on the approved minimum physical device.
- The device gate uses at least 30 five-second samples per language across multiple speakers and ordinary quiet indoor conditions.
- Target median word error rate: English <= 15%; Persian <= 30%. Target transcription latency: <= 5 seconds p95 after durable capture.
- A failed physical-device gate blocks release completion but does not delete captures or disable editing/retry.

## Acceptance criteria

1. Automatic stop occurs at 5 seconds and only one durable capture is committed.
2. Stop creates a retained WAV, session-linked Bite, media reference, and queued job atomically at the database boundary.
3. Cancel, permission denial, and pre-durability failure leave no session, Bite, media row, or job.
4. Transcription is on-device, English/Persian capable, restart-safe, retryable, and editable.
5. Source retention, assignment inheritance, localization, RTL, large text, and accessibility remain intact.
6. Automated repository, duration-contract, retry/recovery, and data-preservation tests pass; physical quality evidence is recorded separately.
