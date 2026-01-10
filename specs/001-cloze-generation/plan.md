# Implementation Plan: Basic Cloze Generation

**Branch**: `001-cloze-generation` | **Date**: 2026-01-10 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-cloze-generation/spec.md`

## Summary

Build a CLI tool that converts input text into Anki cloze deletion format. Each word in the
input becomes a separate cloze deletion numbered sequentially (e.g., "A fool" →
"{{c1::A}} {{c2::fool}}"). The tool accepts input via stdin or command-line arguments and
outputs to stdout.

## Technical Context

**Language/Version**: Ruby 3.2+
**Primary Dependencies**: None (stdlib only - aligns with Simplicity principle)
**Storage**: N/A (stateless text transformation)
**Testing**: Minitest (Ruby stdlib)
**Target Platform**: Linux, macOS, Windows (any platform with Ruby)
**Project Type**: Single CLI application
**Performance Goals**: Process single line in <1 second (per SC-001)
**Constraints**: UTF-8 text encoding, pipeable output
**Scale/Scope**: Single-user CLI tool, single sentence/line processing

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Requirement | Status |
|-----------|-------------|--------|
| I. Simplicity | No unnecessary dependencies | ✅ Using Ruby stdlib only |
| I. Simplicity | No speculative features | ✅ MVP: single transformation |
| I. Simplicity | Flat over nested | ✅ Simple word-by-word processing |
| II. CLI-First | stdin/args input | ✅ FR-001, FR-002 |
| II. CLI-First | stdout/stderr output | ✅ FR-009 |
| II. CLI-First | Exit codes | ✅ FR-010 |
| II. CLI-First | Pipeable | ✅ SC-005 |
| III. Test-First | Tests before implementation | ✅ Will follow TDD |

**Gate Status**: PASS - No violations

## Project Structure

### Documentation (this feature)

```text
specs/001-cloze-generation/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (CLI contract)
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
bin/
└── anki-cloze           # CLI entry point (executable)

lib/
└── anki_cloze.rb        # Core transformation logic

test/
├── test_helper.rb       # Test configuration
└── anki_cloze_test.rb   # Unit tests
```

**Structure Decision**: Single project structure. Minimal layout with `bin/` for executable,
`lib/` for core logic, and `test/` for Minitest tests. No separation of models/services
needed for this simple text transformation.

## Complexity Tracking

> **No violations - table not needed**

The design follows all constitution principles without requiring justification for complexity.
