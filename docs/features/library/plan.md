Documentation-Only Library MVP Spec Update
Summary
Do not implement or modify application code.
The specification will separate:
the simple MVP Library that must be built now; and
the supplied visual reference as the intended long-term design direction.
MVP Requirements
Preserve the existing app shell, bottom navigation, and global capture controls.
Display active local PersonalBooks on one vertically scrollable page.
Use a simple, accessible, spine-inspired shelf presentation with existing Sage and Paper tokens.
Provide a compact heading and Add Book action.
Order books newest-first and exclude archived books.
Add Book opens Discover Active Search with an empty query.
Selecting a book passes its local ID to the future PersonalBook Detail route; that page remains separately specified.
Support empty, loading, populated, local-error, retry, offline, restoration, English LTR, Persian RTL, large text, screen readers, and reduced motion.
Exclude search, filters, progression, achievements, decorations, customization, accounts, notifications, and detailed book-page behavior.
Future Visual Direction
Record the supplied image as the end-goal inspiration for a calm, warm, friendly, physical personal library.
The future direction may introduce richer shelving, environmental decoration, lighting, personalization, and a more immersive room-like composition through separate approved work. These visuals are not MVP requirements or acceptance criteria.
Keep the MVP presentation structurally adaptable through simple screen sections—header, shelf content, book item, and Add Book action—so the Library can later be visually upgraded without changing its domain model or local data contract. Do not create speculative decoration models, progression services, theme systems, or unused abstractions now.
The image’s bottom navigation, profile, notifications, and progress widgets are not design targets. BookBite’s existing navigation remains authoritative.
Verification
Confirm the rewritten document uses canonical PersonalBook and Library terminology.
Confirm current MVP requirements are clearly separated from future visual aspirations.
Confirm every MVP state and outgoing route has testable acceptance criteria.
Confirm no future decoration or progression requirement becomes an implementation dependency.
Confirm the update changes documentation only.
Assumptions
The supplied visual is retained as long-term inspiration, not an approved MVP screen.
“Open a book” defines only the Library’s navigation handoff; PersonalBook Detail remains another feature.
The repository file remains unchanged while this task is in Plan Mode; the eventual execution is limited to rewriting the Library specification document.