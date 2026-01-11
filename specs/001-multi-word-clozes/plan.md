# Implementation Plan: Multi-Word Cloze Generation

**Branch**: `001-multi-word-clozes` | **Date**: 2026-01-11 | **Spec**: [specs/001-multi-word-clozes/spec.md](spec.md)
**Input**: Feature specification from `/specs/001-multi-word-clozes/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Generate multi-word Anki cloze deletions automatically from plain text sentences. System accepts a sentence and generates exhaustive cloze cards for all chunk sizes from N=1 to N=ceil(word_count/2), covering all possible non-overlapping arrangements. Uses test-first development with Ruby stdlib only.

## Technical Context

**Language/Version**: Ruby 3.2+  
**Primary Dependencies**: None (stdlib only - aligns with Simplicity principle)  
**Storage**: N/A (pure transformation, no persistence)  
**Testing**: Minitest (stdlib) with test-first TDD workflow  
**Target Platform**: CLI on Linux/macOS/Windows with Ruby installed  
**Project Type**: Single project (CLI tool)  
**Performance Goals**: Process sentences up to 20 words instantly (<100ms)  
**Constraints**: No external dependencies, must output valid Anki format {{c1::text}}  
**Scale/Scope**: Single-sentence input, generating 10-100 output lines depending on word count and chunk sizes

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### I. Simplicity (YAGNI)
- ✅ **Minimal Dependencies**: Using only Ruby stdlib, no external gems
- ✅ **No Speculative Features**: Only generating clozes as specified, no configuration or plugins
- ✅ **Flat Over Nested**: Simple algorithm with clear input/output, no deep abstractions
- ✅ **Delete Before Abstract**: Starting with minimum viable implementation

### II. CLI-First Interface
- ✅ **Input**: Accepts sentence via stdin or command-line argument
- ✅ **Output**: Writes cloze cards to stdout
- ✅ **Exit Codes**: Standard 0 for success, non-zero for errors
- ✅ **Pipeable**: Designed to work in Unix pipelines

### III. Test-First Development
- ✅ **Red-Green-Refactor**: Tests will be written before implementation
- ✅ **Coverage**: All cloze generation logic will have test coverage
- ✅ **No Untested Features**: Implementation only proceeds after tests are written

**Status**: ✅ PASS - No constitution violations. Proceed to Phase 0.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── anki_cloze/
│   ├── generator.rb       # Core cloze generation logic
│   └── formatter.rb       # Anki format output

bin/
└── anki-cloze             # CLI entry point

test/
├── test_helper.rb         # Test setup and utilities
├── generator_test.rb      # Unit tests for Generator
└── formatter_test.rb      # Unit tests for Formatter
```

**Structure Decision**: Single project layout. Using Ruby conventions with `lib/` for source code organized by module, `bin/` for executable, and `test/` for Minitest tests. All code under `lib/anki_cloze/` namespace to avoid conflicts.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

**Status**: No violations - all constitution principles followed

---

## Phase 0: Research - COMPLETED ✅

Generated `research.md` with findings on:
- Combinatorial algorithm for non-overlapping chunk generation
- Ruby Minitest setup and TDD best practices  
- CLI design using OptionParser (stdlib)
- Anki cloze format specification
- Word boundary detection strategy

All NEEDS CLARIFICATION items resolved.

---

## Phase 1: Design & Contracts - COMPLETED ✅

Generated artifacts:
- `data-model.md` - Core entities: Sentence, Chunk, Arrangement, ClozeSet
- `contracts/cli-contract.md` - Complete CLI interface specification
- `quickstart.md` - User guide with examples and TDD workflow
- Updated agent context (GitHub Copilot)

**Post-Design Constitution Re-Check**:
- ✅ **Simplicity**: Pure Ruby stdlib, no external dependencies, flat data model
- ✅ **CLI-First**: Complete stdin/stdout contract defined, Anki format output
- ✅ **Test-First**: Quickstart includes TDD workflow, Minitest setup documented

**Status**: All gates passed. Ready for Phase 2 (tasks generation - separate command).

---

## Next Steps

Run `/speckit.tasks` command to generate the Phase 2 implementation tasks based on this plan.
