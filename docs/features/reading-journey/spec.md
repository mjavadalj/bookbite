# Reading Journey and Basic Progression Feature Specification

**Status:** Approved  
**Approved:** 2026-08-22

## Purpose

Provide a private, calm reflection of the reader's accumulated reading time. This is a ReadingJourney presentation, not an account, public profile, competitive system, or deep analytics dashboard.

## Scope

- Show a private Reader identity header inside Journey; do not create an account or Profile destination.
- Derive total reading time, today's reading time, completed-session count, and current streak from persisted ReadingSessions.
- Show a 16-week contribution heatmap using local calendar days.
- Add basic progression based only on accumulated session duration.
- Keep all calculation local and derived; do not add network access or duplicate progression storage.

## Progression Rules

- A reader starts at Level 1.
- Every 60 accumulated reading minutes advances one level.
- Partial time is shown as progress toward the next 60-minute level.
- The daily reflection goal is 30 minutes and does not award currency or unlock features.
- Active-session time contributes up to the current time.
- Sessions that cross midnight are divided across the local calendar days they occupy.
- A streak is informational only. It creates no loss state, pressure, notification, or penalty.

## Heatmap

- Display Monday through Sunday for the current and previous 15 weeks.
- Use five intensity levels: none, under 15 minutes, 15–29, 30–59, and 60 or more.
- Every cell exposes its date and minutes through semantics and a tooltip; color is not the only source of meaning.
- Future days are visually absent and do not imply missing activity.

## Accessibility, Privacy, and Failure Behavior

- English LTR and Persian RTL are supported.
- The page is vertically scrollable and remains usable in phone landscape.
- Reading data never leaves the device and is never logged.
- Loading shows progress feedback. An empty history produces valid Level 1 and zero-state values rather than an error.
- No Journey interaction mutates ReadingSessions or creates progression records.

## Acceptance Criteria

- Ending a persisted ReadingSession updates Journey without restart.
- Duration aggregation, active sessions, midnight distribution, level progress, and streak behavior have deterministic unit coverage.
- Widget coverage verifies the progression card, heatmap, phone landscape, and absence of layout exceptions.

