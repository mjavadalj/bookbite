# Feature Specification: PersonalBook Detail

**Status:** Approved
**Last updated:** 2026-08-22

## Purpose and scope

PersonalBook Detail is the offline local record for a reader-owned book. It shows the permanent metadata snapshot, persisted reading sessions, and every text/photo/voice Bite assigned to that book.

## Requirements

- Load only by stable local PersonalBook ID and perform no catalog request.
- Preserve imported or manually created metadata across restart and catalog-cache eviction.
- Show sessions newest first with active/completed state and derived duration.
- Show assigned Bites newest first, retain their managed photo or voice source, and expose persistent plain-text editing when extraction is ready.
- A missing record shows localized recovery without modifying any data.
- English LTR, Persian RTL, mixed-direction content, large text, safe areas, screen readers, 48dp controls, and reduced motion are required.

## Acceptance criteria

1. Manual and imported PersonalBooks reopen offline with their stored snapshot.
2. Session and Bite projections survive database close/reopen.
3. Photo and voice media remain attached to the correct Bite and PersonalBook.
4. Edited OCR or transcript text reopens with the reader's latest saved value.
5. Catalog failures and cache eviction cannot alter the page's personal data.

