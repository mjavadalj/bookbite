# App Navigation

## Purpose

This document defines the global navigation structure of BookBite and describes how users move between the main areas of the app.

The goal is to keep the app simple, predictable, and fast to navigate while supporting both discovery and personal reading workflows.

---

## Navigation Principles

* The app should feel simple and immediate.
* The user should always know where they are.
* Core reading actions should be reachable with minimal friction.
* Capture Bite is a universal action and should be accessible from anywhere.
* Reading Session should be the main working space during active reading.
* Discover and personal reading areas should remain clearly separated.

---

## Primary Navigation Structure

BookBite should use a small set of main destinations.

### Main Destinations

1. **Library**
2. **Discover**
3. **Reading Session**
4. **Profile**
5. **Settings**

### Global Action

* **Capture Bite**
  A universal action available from all major screens.

---

## Main Areas

### 1. Library

The Library is the user's personal reading space.

It represents the reader's relationship with books and should feel like a personal place that grows over time.

The Library is not only a collection of books. It is a visual representation of the user's reading journey.

It should create a feeling of:

- Ownership
- Progress
- Personal growth
- Emotional connection with books

It may include:

- Personal books
- Reading progress
- Current reading activity
- Reading milestones
- Lightweight gamification elements
- Achievements and rewards connected to the user's journey

The Library is designed to make users feel:
"This is my reading world."

---

### 2. Discover

Discover is the catalog browsing area.

It should allow the user to:

* Search books
* Browse catalog results
* Open a book overview
* Add a book to the personal library

Discover is for finding books, not for managing the personal reading journey.

---

### 3. Reading Session

Reading Session is the active reading workspace.

It should support:

* Starting a reading session
* Enabling Focus Mode
* Capturing Bites while reading
* Seeing session-related captures
* Ending the session

Reading Session is the most important active workspace during reading.

---

### 4. Profile

Profile represents the user's reading identity.

Unlike Library, which is a personal reading space, Profile is a user identity page that can eventually be shared with others.

It should feel similar to a personal social profile, but focused on books rather than social engagement.

It may include:

- User information
- Reading statistics
- Reading journey summary
- Ranks
- Achievements
- Favorite books
- Reading patterns
- Public-facing reading identity

Profile answers:

"Who is this reader?"

### 5. Settings

Settings should contain:

* Language
* OCR preferences
* Sync preferences
* Appearance preferences
* General app settings

Settings should remain lightweight and easy to reach.

---

## Screen Types

BookBite has two different contexts for books.

### 1. Book Overview

Book Overview is the catalog-facing view.

It is reached from Discover and should show:

* Book cover
* Title
* Author
* Description
* Metadata
* Catalog-based information
* Add to Library action
* Start Reading action

This screen helps the user decide whether they want to read the book.

---

### 2. My Book

My Book is the personal book view.

It is reached from Library and should show:

* Reading status
* Reading cycles
* Reading sessions
* Bites
* Notes
* Personal progress
* Continue Reading action

This screen reflects the user's personal relationship with the book.

---

## Reading Session Flow

A reading session should be treated as a focused working state.

Typical flow:

1. User opens a book from Library.
2. User starts a Reading Session.
3. User optionally enables Focus Mode.
4. User captures Bites during the session.
5. User reviews captured Bites during or after the session.
6. User ends the session.
7. Session data remains available in the book and profile contexts.

Capture Bite should always remain available globally, but it should feel most prominent inside Reading Session.

---

## Capture Bite Flow

Capture Bite is not a page.

It is a global action.

It should be accessible from:

* Library
* Discover
* Book Overview
* My Book
* Reading Session
* Profile

However, the primary and most natural place for it is inside Reading Session.

---

## Navigation Map

```text
Library
├── Personal Shelves
├── Current Reading
├── Completed Books
├── Reading Progress
├── Achievements
└── My Book
│   ├── Reading Cycles
│   ├── Reading Sessions
│   ├── Bites
│   └── Continue Reading
│
Discover
├── Search
├── Book Overview
└── Add to Library
│
Reading Session
├── Focus Mode
├── Capture Bite
├── Session Bites
└── End Session
│
Profile
├── Reading Journey
├── Achievements
├── Statistics
├── Reading Identity
├── Statistics
├── Ranks
├── Achievements
├── Favorite Books
├── Public Profile (Future)
└── Personal Summary
│
Settings
├── Language
├── OCR
├── Sync
└── Appearance
```

---

## Future Expansion

This navigation structure is intentionally small and clear.

Future versions may add:

* Public profile views
* Shared reading pages
* Reading recommendations
* Community features
* More detailed journey screens

These additions should not break the core simplicity of the current navigation model.
