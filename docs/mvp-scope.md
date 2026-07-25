# MVP Scope

**Project Name:** BookBite *(Working Title)*

---

# MVP Goal

The purpose of the MVP is to validate BookBite's core promise:

> Readers can capture meaningful notes from physical books without interrupting their reading experience.

The MVP should prove that BookBite makes book note-taking significantly easier than traditional methods while preserving a calm, personal, and enjoyable reading experience.


# Success Criteria

The MVP is successful if users can:

- Discover or create the book they are reading.
- Build a personal library of books.
- Track their reading journey.
- Capture important pages from physical books in seconds.
- Convert captured pages into editable Book Bites.
- Continue reading immediately after capturing a note.
- Review and edit notes later.
- Continue using the application even without an internet connection.


# In Scope

## Personal Library

Users can:

- Browse books through an external book catalog.
- Manually create a book when it is unavailable in the catalog.
- Build and manage their personal library.
- View book details.

Manual creation only affects the user's personal library and does not modify the global book catalog.


## Reading Status

Each book can have one of the following states:

- Want to Read
- Reading
- Paused
- Finished
- Dropped

The application should support multiple reading cycles for the same book while preserving the user's Reading Journey.


## Book Bite

Users can:

- Capture pages from physical books using the device camera.
- Convert captured pages into editable text using OCR.
- Save Bites immediately.
- Edit Bites at any time.
- Organize notes within each book.

Bites can initially exist without a connected Book or Reading Cycle and can be organized by the user later.

OCR may be performed locally or through cloud services depending on availability and user preference.

The primary objective is preserving the reader's flow with the least possible friction.


## Focus Reading Sessions

Users may optionally start a Focus Reading Session before reading.

Focus Sessions provide:

- A calm, distraction-reduced reading experience.
- Reading session tracking.
- Reading Session records.
- The foundation of the user's reading journey.

BookBite capture must always remain available, even when Focus Mode is not active.


## Reading Journey

The MVP includes lightweight progression that celebrates reading without turning the experience into a game.

This includes:

- Reading Journey
- Reading sessions
- Reading milestones
- Reading ranks
- Simple achievements

Progression should encourage consistent reading while keeping books—not rewards—at the center of the experience.


## Offline Experience

Once a book has been added to the user's library, the core reading workflow should work completely offline.

Users should be able to:

- Access their personal library.
- Read previously added books.
- Capture Bites.
- Edit Bites.
- Continue Focus Sessions.
- View Reading Journey.

Internet access is required only for features that depend on external services, such as:

- Book discovery
- Account synchronization
- Cloud OCR (if selected)
- Future social features

## Account & Synchronization

Creating an account is optional.

Users can start using BookBite immediately without registration.

Creating an account enables:

- Cloud backup
- Synchronization across devices
- Future social capabilities

Local data always remains the primary source of truth.


## Localization

The MVP supports:

- English
- Persian (RTL)

The application architecture should allow additional languages to be added with minimal effort.


# Out of Scope

The MVP intentionally does not include:

- AI-generated summaries
- AI note refinement
- AI OCR correction
- Rich text editing
- Sticky notes
- Highlights
- Tags and folders
- Advanced search inside notes
- Reading analytics and deep statistics
- Personalized recommendations
- Reviews and ratings
- Public profiles
- Following other readers
- Comments
- Community features
- Reading clubs
- Multi-device real-time collaboration

These capabilities belong to future versions after the core reading workflow has been validated.


# Product Constraints

Every feature added to the MVP should support the primary reading workflow.

The MVP should prioritize:

- Minimal friction
- Offline-first experience
- Local-first data ownership
- Fast and responsive interactions
- Smooth animations
- Reliable OCR
- Clear and simple user flows
- Calm and personal user experience

Technology should never become the center of attention.

Reading and preserving meaningful moments should.

# What We Are Validating

This MVP exists to answer one fundamental question:

> Will readers naturally choose BookBite as part of their reading habit because it allows them to preserve meaningful moments without breaking their immersion?

If the answer is yes, BookBite has validated its foundation and can confidently evolve into a richer personal reading companion.