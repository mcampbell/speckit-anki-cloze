# Tasks: Basic Cloze Generation

**Input**: Design documents from `/specs/001-cloze-generation/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Included per Constitution Principle III (Test-First Development)

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `bin/`, `lib/`, `test/` at repository root (per plan.md)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Create project directory structure: bin/, lib/, test/
- [x] T002 Create Rakefile with test task in Rakefile
- [x] T003 [P] Create .ruby-version file with ruby 3.2.0

**Checkpoint**: Project structure ready for development

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Create test helper with Minitest configuration in test/test_helper.rb
- [x] T005 Create executable CLI entry point stub in bin/anki-cloze

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Generate Cloze from Text (Priority: P1) 🎯 MVP

**Goal**: Convert input text to Anki cloze deletion format where each word becomes a numbered cloze

**Independent Test**: Run `./bin/anki-cloze "A fool and his money"` and verify output is `{{c1::A}} {{c2::fool}} {{c3::and}} {{c4::his}} {{c5::money}}`

### Tests for User Story 1 (TDD - Constitution Principle III)

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [x] T006 [P] [US1] Unit test for word-to-cloze transformation in test/anki_cloze_test.rb
- [x] T007 [P] [US1] Unit test for sentence-to-cloze conversion in test/anki_cloze_test.rb
- [x] T008 [P] [US1] Unit test for empty input handling in test/anki_cloze_test.rb
- [x] T009 [US1] Integration test for CLI with ARGV input in test/anki_cloze_test.rb
- [x] T010 [US1] Integration test for CLI with stdin input in test/anki_cloze_test.rb

### Implementation for User Story 1

- [x] T011 [US1] Implement ClozeItem formatting method in lib/anki_cloze.rb
- [x] T012 [US1] Implement sentence splitting and transformation in lib/anki_cloze.rb
- [x] T013 [US1] Implement ARGV input handling in bin/anki-cloze
- [x] T014 [US1] Implement stdin input handling in bin/anki-cloze
- [x] T015 [US1] Implement error handling with stderr output in bin/anki-cloze
- [x] T016 [US1] Implement exit codes (0 success, 1 error) in bin/anki-cloze

**Checkpoint**: User Story 1 fully functional - MVP complete

---

## Phase 4: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and documentation

- [x] T017 Run all tests and verify 100% pass rate
- [x] T018 Run quickstart.md verification checklist
- [x] T019 [P] Add --help flag with usage information in bin/anki-cloze

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS user stories
- **User Story 1 (Phase 3)**: Depends on Foundational phase completion
- **Polish (Phase 4)**: Depends on User Story 1 being complete

### Within User Story 1

1. Tests (T006-T010) MUST be written and FAIL before implementation
2. Core logic (T011-T012) before CLI integration (T013-T016)
3. ARGV handling (T013) before stdin handling (T014)
4. Error handling (T015) and exit codes (T016) last

### Parallel Opportunities

- T006, T007, T008 can run in parallel (different test cases, same file but independent)
- T003 can run in parallel with T001, T002

---

## Parallel Example: User Story 1 Tests

```bash
# Launch all unit tests together (TDD red phase):
Task: "Unit test for word-to-cloze transformation in test/anki_cloze_test.rb"
Task: "Unit test for sentence-to-cloze conversion in test/anki_cloze_test.rb"
Task: "Unit test for empty input handling in test/anki_cloze_test.rb"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1 (TDD: tests first, then implementation)
4. **STOP and VALIDATE**: Run `./bin/anki-cloze "A fool and his money"`
5. Complete Phase 4: Polish

### TDD Workflow (per Constitution)

For each implementation task in Phase 3:

1. Write test (RED) → Verify test fails
2. Implement feature (GREEN) → Verify test passes
3. Refactor if needed → Verify tests still pass
4. Commit

---

## Notes

- [P] tasks = different files or independent sections, no dependencies
- [US1] label maps task to User Story 1 for traceability
- Constitution requires Test-First: write tests before implementation
- Single user story = simplified task structure
- Commit after each task or logical group
- Verify tests fail before implementing (TDD red phase)
