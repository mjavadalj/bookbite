# BookBite Catalog Flow UI/UX Baseline

## Direction

This design set establishes the approved MVP baseline for Discover and CatalogBook surfaces.

The experience uses the bright Sage and Paper theme: calm, personal, warm, cover-led, minimal, and modern. Warmth comes from paper-like surfaces, restrained sage interactions, book artwork, and reader-centered language rather than decorative chrome. Catalog discovery remains separate from the reader's local Library.

Reference screens:

- `approved-mvp/01-discover-browse.png`
- `approved-mvp/02-catalog-book-hero.png`
- `approved-mvp/03-catalog-book-scrolled.png`
- `approved-mvp/04-discover-search.png`

## Shared Visual System

| Token | Value | Use |
|---|---:|---|
| Canvas | `#F3EFE6` | Warm paper background |
| Surface | `#FBF8F1` | Cards, bars, and controls |
| Soft surface | `#F7F2E8` | Low-emphasis grouped content |
| Text primary | `#293128` | Titles and primary content |
| Text secondary | `#6E7268` | Authors, metadata, helper text |
| Border | `#DDD5C8` | Hairline dividers and outlines |
| Interaction | `#566A4A` | Accessible focus, selection, and primary actions |
| Atmospheric sage | `#8FA07C` | Non-text decoration and low-emphasis fills |
| Cover apricot | `#EE9276` | Primary CatalogBook cover family |
| Cover mint | `#62C8A5` | Supporting cover family |
| Cover lavender | `#A9A1E8` | Supporting cover family |
| Cover amber | `#F2A126` | Supporting cover family |

- Use a modern humanist sans-serif with localized Persian support.
- Use an 8dp spacing grid and 48dp minimum touch targets.
- Use 16-24dp corner radii for controls and major surfaces.
- Prefer hairline dividers to card containers.
- Use soft natural depth sparingly; do not use gradients, glow, glass blur, strong texture, or large shadows.
- Cover art supplies visual variety; application chrome stays quiet.
- The MVP has no theme selector. Ember and Ink remains a post-MVP exploration.

## Discover Browse

- The page scrolls vertically.
- The category rail scrolls horizontally and preserves its position when returning from a child route.
- A partially visible final chip communicates horizontal overflow without instructional copy.
- `All` is the only functional MVP category. The other approved chips remain visible; activation shows calm localized future-availability feedback without changing results.
- The first shelf scrolls horizontally. The catalog grid remains vertical to avoid competing gestures.
- Selecting a book opens CatalogBook detail. It does not add the book directly.
- Filter remains visible in the MVP; activation shows calm localized future-availability feedback without opening a sheet or changing results.
- Photo and Voice remain equal compact actions above the five-destination navigation.

## CatalogBook Detail

- The initial state prioritizes cover, title, author, subjects, a short description, and one primary `Add to your library` action.
- Adding imports a local metadata snapshot and opens the resulting PersonalBook detail.
- The local/offline helper text communicates what adding does without implying cloud ownership.
- As the user scrolls, the hero collapses into a pinned header containing Back, cover, title, author, and Add.
- The Add action appears only once in the visible viewport. The body CTA scrolls away before the compact header action appears.
- With reduced motion enabled, the header switches states without cover interpolation or parallax.
- Related books are catalog relationships, not personalized recommendations.
- Returning to Discover restores query, loaded results, rail position, and scroll position.
- CatalogBook detail does not expose Photo or Voice. Back returns to Discover, where capture remains available.

## Active Search

- Focusing the search field opens a dedicated search surface with Cancel and preserves the Discover root beneath it.
- Search is debounced. Existing results remain visible while a refresh is pending.
- Matching text uses emphasis plus an underline; color is not the only signal.
- Selecting a result opens CatalogBook detail and preserves the query for Back navigation.
- Empty, unavailable, and offline states always expose manual PersonalBook creation.
- Cancel dismisses search and restores the previous Discover state.
- Focused catalog search does not expose Photo or Voice. Cancel returns to the Discover root, where capture remains available.

## Capture Placement

- Photo and Voice have equal size, contrast, and hierarchy.
- Capture opens above the current route and does not replace its navigation stack.
- On the Discover root, the capture pair sits immediately above the five-item navigation.
- CatalogBook detail and focused catalog search intentionally omit capture controls to keep catalog evaluation and search focused.
- Back or Cancel restores the Discover root and its capture pair.

## Accessibility and Localization

- Book semantics announce title, author, edition/language when available, and action.
- Cover art is never the only book identifier.
- English LTR and Persian RTL mirror layout and navigation direction intentionally.
- Mixed-direction titles and author names remain isolated in their natural text direction.
- Dynamic text may change the grid to two columns or a list; titles wrap instead of truncating essential identity.
- Horizontal shelves expose accessible next/previous scrolling and never require a swipe-only action.
- All text and interactive icons meet WCAG 2.2 AA contrast expectations.

## Required States

The implementation must define populated, loading, no-results, offline, catalog-unavailable, recoverable-error, and missing-cover states. Existing local content and other main destinations remain usable when catalog search is unavailable.
