# BookBite Constitution

**Version:** 2.1

## Purpose

This constitution defines the non-negotiable principles for BookBite. Product, design, engineering, and feature specifications must comply with them.

In these specifications:

- **must** means required;
- **should** means strongly preferred unless a documented reason prevents it;
- **may** means optional.

## 1. Reader First

BookBite exists to help readers preserve meaningful moments from physical books without interrupting reading.

Every capability must strengthen the reader's relationship with books. Technology must support reading, not compete with it.

## 2. Frictionless Capture

Capturing a Bite must require minimal effort. The app must confirm as soon as its page image or voice recording is safely stored so the reader can continue while text extraction finishes.

When functionality conflicts with reading flow, reducing interruption takes priority.

## 3. Local First

The complete core workflow must work offline from first launch:

- capture an assigned or unassigned Bite;
- save its source image or voice recording durably;
- process OCR or speech-to-text on-device;
- view and edit its text;
- access the personal Library and ReadingJourney.

Network services may enhance the product but must not own or enable the core workflow.

## 4. Personal Ownership and Privacy

PersonalBooks, ReadingCycles, ReadingSessions, Bites, source images, voice recordings, and edits belong to the reader.

User data must remain locally accessible. It must not be silently discarded, uploaded, logged, or exposed. Destructive actions must state their effect; permanent deletion requires explicit confirmation.

## 5. Calm, Simple, and Consistent

The experience must remain calm, predictable, and easy to understand. Prefer simple solutions over clever or speculative ones.

The same action must behave consistently across the product. Motion should explain change or confirm action, never delay the reader or demand attention.

## 6. Performance and Quality

Responsiveness is a product requirement. User actions must receive immediate feedback, and background work must not block unrelated interaction.

A feature is complete only when its positive, negative, empty, loading, offline, accessibility, localization, and recovery states are defined and verified.

Each feature specification must set measurable performance and quality criteria appropriate to that feature.

## 7. Inclusive Design

English LTR and Persian RTL are first-class experiences. Localization, bidirectional layout, screen-reader semantics, dynamic text, contrast, touch targets, focus order, and reduced motion must be considered from the start.

No essential meaning or action may depend only on color, imagery, orientation, or animation.

## 8. Calm Progression

Achievements, milestones, and ranks may celebrate reading, consistency, and exploration. They must remain minimal, predefined, and non-competitive.

BookBite must not use leaderboards, social comparison, streak-loss pressure, shame, artificial urgency, or reward-first navigation.

## 9. Build for Evolution

The system should grow through replaceable interfaces and clear module boundaries, not speculative infrastructure or large rewrites.

Post-MVP services such as cloud text extraction, accounts, backup, synchronization, and social features must remain optional and must not redefine the local domain.

## 10. Specification Governance

The seven core specifications are peer authorities with distinct responsibilities:

- `vision.md`: product purpose and boundaries;
- `constitution.md`: non-negotiable principles;
- `mvp-scope.md`: MVP capabilities and exclusions;
- `domain-model.md`: canonical concepts and invariants;
- `architecture.md`: system structure and data flow;
- `tech-stack.md`: technology decisions;
- `design-system.md`: interaction and presentation rules.

Overlapping statements must remain semantically consistent. A conflict blocks implementation and must be resolved with the product owner; it must never be settled by assumption.

Feature specifications may add detail but must not silently override a core specification.

## Final Test

Before introducing any product, design, or engineering change, ask:

> Does this help readers preserve meaningful moments without pulling them out of the book they are reading?

If not, reconsider it.
