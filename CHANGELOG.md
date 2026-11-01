# Changelog

## Unreleased

### Step 1 — Library
- Import EPUB files through the system document picker; files are copied into app storage.
- EPUB parsing runs in a background isolate: title, author, embedded cover and an approximate word count.
- Duplicate imports (same title, author and file size) are detected and skipped.
- Library grid with the book's cover (or a generated typographic cover), title, author, % progress and estimated time left.
- Sort by last opened, title or progress.
- Swipe a book left to delete it, with confirmation; its stored file and cover are removed too.
- Two bundled public-domain samples from Project Gutenberg: *Alice's Adventures in Wonderland* and *The Adventures of Sherlock Holmes* ("Add sample books").
- Tapping a book opens a details screen (the reader replaces it in step 3).
- Android: min SDK 26, arm64-v8a only.

Not yet: PDF import (comes in the PDF step, after the reader and TTS).
