# Feature Specification: Multi-Word Cloze Generation

**Feature Branch**: `001-multi-word-clozes`  
**Created**: 2026-01-11  
**Status**: Draft  
**Input**: User description: "handle multiple sized clozes - this feature will allow the application to generate multi-word clozes, in order that the user should memorize pieces of a sentence as chunks as opposed to each word individually"

## Clarifications

### Session 2026-01-11

- Q: How do users specify chunks - by word position (e.g., words 2-4), by text selection, by markup in the input, or other method? → A: Users do NOT specify chunks. Input is plain text sentence only. App automatically generates exhaustive output for ALL chunk sizes from N=1 up to N=ceil(word_count/2). For a 5-word sentence, generate all 1-word, 2-word, and 3-word clozes. For a 6-word sentence, also generate 1-word, 2-word, and 3-word clozes. Multiple non-overlapping clozes may appear on the same line. For "foo bar baz" (3 words), output includes N=1 clozes ({{c1::foo}} bar baz, etc.) and N=2 clozes ({{c1::foo bar}} baz, foo {{c1::bar baz}}). This is automatic generation, not user specification.
- Q: How does the system define word boundaries with contractions (e.g., "don't") and hyphens (e.g., "well-known")? → A: Contractions are single words. Hyphenated words are also single words.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Generate Multi-Word Cloze Deletions (Priority: P1)

A user wants to create flashcards that test understanding at multiple levels - from individual words to meaningful phrases. They provide a plain text sentence and the system automatically generates cloze deletions for all chunk sizes from 1-word up to ceil(word_count/2)-word, covering all possible arrangements of non-overlapping consecutive clozes.

**Why this priority**: This is the core functionality that enables multi-level memorization from individual words through progressively larger phrase chunks. This graduated approach supports learning at multiple granularities.

**Independent Test**: Can be fully tested by providing a sentence and verifying the output contains cloze deletions for all chunk sizes from N=1 to N=ceil(word_count/2), with all possible arrangements of non-overlapping consecutive clozes for each N.

**Acceptance Scenarios**:

1. **Given** a sentence "The quick brown fox" (4 words), **When** system generates cloze cards, **Then** output contains N=1 clozes ({{c1::The}} quick brown fox, etc.), N=2 clozes ({{c1::The quick}} {{c1::brown fox}}, etc.)
2. **Given** a sentence "one two three four five" (5 words), **When** system generates cloze cards, **Then** output includes N=1, N=2, and N=3 clozes with all arrangements for each size
3. **Given** a sentence with 6 words, **When** system generates all clozes, **Then** system generates clozes for N=1, N=2, and N=3 (ceil(6/2)=3)

---

### User Story 2 - Handle Variable Sentence Lengths (Priority: P2)

A user provides sentences of different lengths and expects the system to automatically determine the appropriate maximum chunk size (ceil(word_count/2)) and generate all cloze sizes from 1 up to that maximum.

**Why this priority**: Sentences vary in length, and the maximum meaningful chunk size should scale with sentence length to provide appropriate granularity of practice.

**Independent Test**: Can be tested by providing sentences of different lengths (3, 4, 5, 6, 10 words) and verifying that each generates clozes from N=1 up to N=ceil(word_count/2).

**Acceptance Scenarios**:

1. **Given** a sentence with 5 words "The United States Supreme Court", **When** system generates clozes, **Then** output includes N=1, N=2, and N=3 clozes (ceil(5/2)=3)
2. **Given** a sentence with 6 words, **When** system generates clozes, **Then** output includes N=1, N=2, and N=3 clozes (ceil(6/2)=3)
3. **Given** a sentence with 3 words "foo bar baz", **When** system generates clozes, **Then** output includes N=1 and N=2 clozes (ceil(3/2)=2)

---

### User Story 3 - Handle Punctuation in Multi-Word Clozes (Priority: P3)

A user creates cloze deletions that include words with punctuation (commas, apostrophes, hyphens) and expects the punctuation to be handled correctly within the chunk.

**Why this priority**: Real-world text includes punctuation that's part of phrases. This ensures natural language handling but is lower priority than core chunking functionality.

**Independent Test**: Can be tested by creating multi-word clozes containing various punctuation marks and verifying punctuation is preserved correctly within the cloze deletion.

**Acceptance Scenarios**:

1. **Given** a sentence "It's a well-known fact that practice makes perfect", **When** user specifies "It's a well-known fact" as a cloze, **Then** system preserves apostrophes and hyphens within the chunk
2. **Given** a sentence with comma-separated phrases, **When** user includes a comma within a multi-word cloze like "First, we analyze", **Then** system includes the comma as part of the deletion

---

### Edge Cases

- How does the system handle a sentence with only 1 or 2 words?
- How does the system handle very long sentences (20+ words) that would generate many output lines?
- How does the system handle sentences with unusual spacing or formatting?
- What is the algorithm for generating all possible non-overlapping arrangements for a given N?
- How many output lines should be generated for a given sentence and each N value?
- Should the output be grouped by N value (all N=1, then all N=2, etc.) or interleaved?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST accept a plain text sentence as input (no N parameter required from user)
- **FR-002**: System MUST automatically calculate maximum chunk size as ceil(word_count/2)
- **FR-003**: System MUST generate cloze deletions for all chunk sizes from N=1 to N=ceil(word_count/2)
- **FR-004**: System MUST generate all possible non-overlapping arrangements of N-word consecutive cloze deletions for each N value
- **FR-005**: System MUST output multiple lines, each containing a different arrangement of non-overlapping clozes
- **FR-006**: System MUST preserve word order and spacing within multi-word cloze deletions
- **FR-007**: System MUST handle punctuation within multi-word clozes (apostrophes, hyphens, commas) as part of the chunk
- **FR-008**: System MUST output each arrangement on a separate line in Anki cloze format: {{c1::words}}
- **FR-009**: System MUST maintain visible context (non-cloze words) in each generated card to provide learning scaffolding
- **FR-010**: System MUST treat contractions (e.g., "don't", "it's") and hyphenated terms (e.g., "well-known") each as single words for chunking purposes

### Key Entities

- **Source Sentence**: The original text from which cloze cards are generated; contains complete information before any deletions
- **Chunk Size (N)**: The number of consecutive words to include in each cloze deletion; automatically varies from 1 to ceil(word_count/2)
- **Maximum Chunk Size**: Calculated as ceil(word_count/2); determines the largest N value to generate (e.g., 5-word sentence → max N=3)
- **Cloze Chunk**: A contiguous sequence of N consecutive words from the source sentence that will be hidden together as a single unit
- **Cloze Card/Line**: The generated flashcard output with one or more non-overlapping N-word consecutive chunks hidden in Anki format ({{c1::words}}) and the rest of the sentence visible as context
- **Word Boundary**: The definition of what constitutes a word unit for chunking purposes; contractions (e.g., "don't") and hyphenated terms (e.g., "well-known") are each treated as single words
- **Arrangement**: A specific pattern of non-overlapping N-word clozes on a single output line; different arrangements provide different learning contexts for the same phrase chunks

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: System successfully generates cloze cards for all N from 1 to ceil(word_count/2) for sentences with 3-10 words
- **SC-002**: For a 5-word sentence, system generates N=1, N=2, and N=3 clozes; for a 6-word sentence, also generates N=1, N=2, and N=3
- **SC-003**: 100% of multi-word cloze generations preserve exact word order and spacing from the original sentence
- **SC-004**: System correctly generates multiple output lines with different non-overlapping arrangements for each chunk size N
- **SC-005**: System correctly handles sentences containing punctuation within N-word chunks without formatting errors
- **SC-006**: Generated output uses valid Anki cloze format {{c1::text}} that can be imported directly into Anki without manual editing
