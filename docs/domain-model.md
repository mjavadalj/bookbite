# BookBite Domain Model

**Project Name:** BookBite *(Working Title)*

---

# Purpose

This document defines the core concepts and terminology used throughout BookBite.

These definitions create a shared language between product, design, and engineering.


# Core Concepts

## Book

A Book represents a physical book that the user owns, reads, or wants to read.

A Book contains information such as:

- Title
- Author
- Cover image
- Metadata
- Reading status
- Associated Bites
- Reading Journey

A Book can exist in the user's personal library independently from the global book catalog.


## Library

A Library represents the user's personal collection of books inside BookBite.

It contains books that the user:

- Wants to read
- Is currently reading
- Has finished
- Has paused
- Has dropped

The Library represents the user's personal relationship with books.

## Reading Cycle

A Reading Cycle represents one attempt of reading a specific book.

The same book may have multiple Reading Cycles.

Example:

A user reads "The Hobbit" in 2026 and finishes it.

Later, the user starts reading it again in 2028.

These are two separate Reading Cycles.

A Reading Cycle contains:

- Start date
- End date
- Reading status
- Related Reading Sessions
- Related Bites


## Reading Session

A Reading Session represents a focused period of reading activity.

A Reading Session may be started manually through Focus Reading Mode.

A session can contain:

- Start time
- End time
- Duration
- Related Reading Cycle

Reading Sessions are designed to help users build awareness of their reading journey.


## Bite

A Bite is the core captured unit of BookBite.

A Bite represents a meaningful part of a physical book that a user wants to preserve.

A Bite is created when:

1. The user captures a page using the camera.
2. The application extracts text using OCR.
3. The captured content is saved.

A Bite may contain:

- Extracted text
- Original captured image
- User edits
- Creation date
- Related Book (optional)
- Related Reading Cycle (optional)
- Optional Reading Session reference

A Bite can exist without being immediately connected to a book.
Users may organize and assign captured Bites later.

A Bite is not simply a note.

It represents a preserved moment from the user's relationship with a book.

## Unassigned Bite

An Unassigned Bite is a captured Bite that has not yet been connected to a specific Book or Reading Cycle.

This allows users to quickly capture meaningful content without interrupting their reading flow.

Users can organize and connect these Bites later.

## OCR Capture

OCR Capture represents the process of converting a photographed book page into editable text.

OCR Capture may use:

- Local processing
- Cloud processing

The implementation should remain invisible to the reader whenever possible.


## Reading Journey

Reading Journey represents the user's accumulated history with books.

It includes:

- Books read
- Reading cycles
- Sessions
- Bites captured
- Milestones achieved

The purpose is reflection and personal growth, not competition.


## Reading Rank

Reading Rank represents lightweight progression based on reading activity.

Ranks should celebrate consistency and exploration.

They should never create pressure or turn reading into a game-first experience.


## Achievement

An Achievement represents a meaningful reading milestone.

Examples:

- Completing the first book
- Capturing the first Bite
- Maintaining a reading habit

Achievements exist to recognize moments in the user's journey.

They should support motivation without distracting from reading.


# Relationships

User
 |
 ├── Library
 |     |
 |     └── Book
 |            |
 |            └── Reading Cycle
 |                   |
 |                   ├── Reading Sessions
 |                   |
 |                   └── Bites
 |
 └── Unassigned Bites


# Terminology Rules

Use these terms consistently:

| Concept | Use | Avoid |
|---|---|---|
| Bite | Captured book moment | BookNote |
| Reading Cycle | One attempt of reading a book | Reading History |
| Reading Session | One focused reading period | Reading Time |
| Library | User's personal collection | Catalog |
| Book Catalog | External book database | Library |