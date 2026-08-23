# Library Presentation Feature Specification

**Status:** Approved  
**Approved:** 2026-08-22  
**Reference:** Product-owner supplied warm, scrollable bookshelf design

## Purpose

Give the reader a calm, offline view of their PersonalBooks that feels like a personal bookshelf without turning the Library into a decorative or network-dependent catalog.

## Scope

- Keep Library as the collection of active, persisted PersonalBooks.
- Present a vertically scrollable welcome and progress surface.
- Present active books as horizontally scrollable, tappable book spines on a shelf.
- Link every spine to its persisted PersonalBook detail.
- Keep Add book visible and route it to the existing search/manual-creation flow.
- Derive book count, today's reading, current streak, and reader level from local records.

## Invariants

- Opening or scrolling Library performs no domain write.
- Library remains fully usable offline.
- Decorative shelf presentation does not invent covers, metadata, books, or progress.
- Empty, loading, and local-read failure states preserve user data and provide a clear Add action where applicable.
- The supplied reference informs hierarchy, warmth, and shelf presentation; it is not a requirement to bundle a large photographic background.

## Accessibility and Localization

- English LTR and Persian RTL are first-class layouts.
- Primary controls have at least 48dp touch targets and descriptive semantics.
- Book spines expose title and author to assistive technology.
- Text supports 200% scaling without clipping or overflow.
- The page remains usable at 375 logical pixels and in landscape.

## Acceptance Criteria

- Persisted PersonalBooks appear after restart and can be opened from the shelf.
- The root page and shelf both scroll without conflicting with vertical navigation.
- Empty, loading, populated, and local-read error states are visible and localized.
- Responsive widget tests cover small-phone, large-text, Persian RTL, and populated shelf behavior.

