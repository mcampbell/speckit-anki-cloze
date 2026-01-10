# Research: Basic Cloze Generation

**Feature**: 001-cloze-generation
**Date**: 2026-01-10

## Anki Cloze Deletion Format

**Decision**: Use Anki's standard cloze syntax `{{cN::text}}`

**Rationale**: This is the official Anki cloze deletion format documented in the Anki manual.
The format consists of:
- Opening: `{{c`
- Number: sequential integer starting at 1
- Separator: `::`
- Content: the text to be hidden
- Closing: `}}`

**Alternatives Considered**:
- Custom format - Rejected: Would require users to convert before importing to Anki
- Anki's alternate syntax `{{cN::text::hint}}` - Not needed for MVP (no hints required)

## Word Splitting Strategy

**Decision**: Split on whitespace using Ruby's `String#split`

**Rationale**: Ruby's `split` with no arguments splits on whitespace and handles multiple
spaces gracefully. This matches user expectations for "words" in natural text.

**Alternatives Considered**:
- Regex-based splitting (`/\s+/`) - Equivalent behavior, more verbose
- Character-by-character - Overcomplicated for word-level cloze
- Preserve punctuation as separate tokens - Not specified in requirements, violates YAGNI

## Ruby CLI Pattern

**Decision**: Use `ARGV` for arguments and `$stdin` for stdin input

**Rationale**: Ruby stdlib provides simple, portable mechanisms:
- `ARGV` array contains command-line arguments
- `$stdin.read` or `$stdin.gets` for stdin input
- `$stdin.tty?` to detect if input is piped

**Alternatives Considered**:
- OptionParser gem - Overkill for single-argument tool, violates Simplicity
- Thor/Commander gems - External dependencies, violates Simplicity
- Custom argument parsing - Unnecessary when ARGV suffices

## Input Source Priority

**Decision**: Command-line arguments take precedence; fall back to stdin if no args

**Rationale**: This matches Unix convention (e.g., `cat`, `echo`). Users can:
1. `anki-cloze "A fool and his money"` - direct argument
2. `echo "A fool and his money" | anki-cloze` - piped input
3. `anki-cloze < input.txt` - redirected file

**Alternatives Considered**:
- Always require stdin - Less convenient for quick one-liners
- Require explicit flag for stdin - Unnecessary complexity

## Error Handling

**Decision**: Write errors to stderr, exit with code 1

**Rationale**: Standard Unix convention. Allows error messages to be separated from output
in pipelines.

**Alternatives Considered**:
- Specific exit codes per error type - Overcomplicated for MVP
- Raise exceptions without handling - Poor UX, non-standard exit codes

## Testing Framework

**Decision**: Minitest (Ruby stdlib)

**Rationale**: Included in Ruby stdlib, no external dependencies. Sufficient for unit testing
a simple CLI tool. Follows Simplicity principle.

**Alternatives Considered**:
- RSpec - External dependency, more features than needed
- Test::Unit - Also stdlib, but Minitest is more modern and concise

## Open Questions Resolved

All technical questions have been resolved. No NEEDS CLARIFICATION items remain.
