# Feature Specification: Basic Cloze Generation

**Feature Branch**: `001-cloze-generation`
**Created**: 2026-01-10
**Status**: Draft
**Input**: User description: "Basic cloze generation - Generate cloze deletions from input text for Anki flashcards"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Generate Cloze from Marked Text (Priority: P1)

As a learner creating flashcards, I want to input a sentence and have it
converted to Anki cloze deletion format, so I can quickly create study
materials.

**Why this priority**: This is the core functionality that delivers the primary value of the tool.
Without this, the tool has no purpose.

**Independent Test**: Can be fully tested by providing a sentence via command
line arguments and verifying the output contains properly formatted cloze
deletions.

**Acceptance Scenarios**:

Given: `A fool and his money` as input. 
When: Run with that input as a command line argument.
Then: `{{c1:A}} {{c2:fool}} {{c3::and}} {{c4::his}}` {{c5::money}} is produced as output.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST accept text input via stdin
- **FR-002**: System MUST accept text input via command-line argument
- **FR-005**: System MUST output Anki-compatible cloze format `{{cN::text}}`
- **FR-006**: System MUST auto-number cloze deletions sequentially starting from 1
- **FR-009**: System MUST output errors to stderr with descriptive messages
- **FR-010**: System MUST exit with code 0 on success, non-zero on failure

### Key Entities

- **Cloze Deletion**: The Anki-formatted output `{{cN::text}}` where N is the card number
  and text is the content to be revealed.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can convert a single line of marked text in under 1 second
- **SC-003**: 100% of valid Anki cloze syntax is generated (parseable by Anki)
- **SC-004**: Error messages identify the specific location of syntax problems
- **SC-005**: Users can pipe output directly to other tools without modification

## Assumptions

The following reasonable defaults have been assumed:

- **Numbering Start**: Cloze numbers start at 1 (matching Anki's convention)
- **Output Default**: Human-readable plain text output by default 
- **Encoding**: UTF-8 text encoding for input and output
