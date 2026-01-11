---

description: "Implementation tasks for Multi-Word Cloze Generation feature"
---

# Tasks: Multi-Word Cloze Generation

**Input**: Design documents from `/specs/001-multi-word-clozes/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Following test-first development approach as specified in plan.md - ALL implementation tasks must be preceded by corresponding test tasks.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `lib/`, `bin/`, `test/` at repository root
- Using Ruby conventions with module namespace `AnkiCloze`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [X] T001 Create project directory structure with lib/anki_cloze/, bin/, and test/ directories
- [X] T002 Create test/test_helper.rb with Minitest configuration and lib path setup
- [X] T003 [P] Create bin/anki-cloze CLI entry point script with shebang and executable permissions
- [X] T004 [P] Create Rakefile with test runner task for convenience

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T005 Create test/sentence_test.rb with tests for Sentence class initialization and word splitting
- [X] T006 Implement lib/anki_cloze/sentence.rb with word parsing, validation, and word_count methods
- [X] T007 [P] Create test/chunk_test.rb with tests for Chunk class initialization and to_s method
- [X] T008 [P] Implement lib/anki_cloze/chunk.rb with start_index, size, words attributes and end_index method
- [X] T009 Create test/formatter_test.rb with tests for Anki format output {{c1::text}}
- [X] T010 Implement lib/anki_cloze/formatter.rb with to_anki_format method for Arrangement

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Generate Multi-Word Cloze Deletions (Priority: P1) 🎯 MVP

**Goal**: Generate cloze deletions for all chunk sizes from N=1 to N=ceil(word_count/2) with all possible non-overlapping arrangements

**Independent Test**: Provide "The quick brown fox" and verify output contains N=1 clozes (4 lines) and N=2 clozes (1 line) in valid Anki format

### Tests for User Story 1 ⚠️

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [X] T011 [P] [US1] Contract test for single-word cloze generation (N=1) in test/generator_test.rb - verify 4-word sentence produces 4 cloze lines
- [X] T012 [P] [US1] Contract test for two-word cloze generation (N=2) in test/generator_test.rb - verify 4-word sentence produces 1 arrangement with 2 clozes
- [X] T013 [P] [US1] Integration test for complete cloze set generation in test/integration_test.rb - verify "The quick brown fox" produces 5 total lines (N=1 and N=2 combined)
- [X] T014 [P] [US1] Test for max_chunk_size calculation in test/cloze_set_test.rb - verify ceil(word_count/2) formula for various word counts

### Implementation for User Story 1

- [X] T015 [P] [US1] Create lib/anki_cloze/arrangement.rb with chunks array, sentence reference, and validation for non-overlapping chunks
- [X] T016 [US1] Implement to_anki_format method in lib/anki_cloze/arrangement.rb that renders chunks with {{c1::text}} format
- [X] T017 [US1] Create lib/anki_cloze/cloze_set.rb with sentence, chunk_size attributes and arrangements array
- [X] T018 [US1] Implement generate_arrangements method in lib/anki_cloze/cloze_set.rb for N=1 (single-word clozes)
- [X] T019 [US1] Extend generate_arrangements in lib/anki_cloze/cloze_set.rb to handle N=2 with non-overlapping logic
- [X] T020 [US1] Create lib/anki_cloze/generator.rb with main generation orchestration logic
- [X] T021 [US1] Implement generate method in lib/anki_cloze/generator.rb that creates ClozeSet for each N from 1 to max_chunk_size
- [X] T022 [US1] Add calculate_max_chunk_size method in lib/anki_cloze/generator.rb using ceil(word_count/2) formula
- [X] T023 [US1] Wire up CLI in bin/anki-cloze to accept argument or stdin and call Generator
- [X] T024 [US1] Add error handling in bin/anki-cloze for empty input with appropriate exit codes and stderr messages

**Checkpoint**: At this point, User Story 1 should be fully functional - can generate basic multi-word clozes for any sentence

---

## Phase 4: User Story 2 - Handle Variable Sentence Lengths (Priority: P2)

**Goal**: Automatically determine appropriate max chunk size for sentences of different lengths (3, 5, 6, 10 words)

**Independent Test**: Provide sentences of various lengths and verify each generates correct N range (3 words → N=1,2; 5 words → N=1,2,3; 6 words → N=1,2,3)

### Tests for User Story 2 ⚠️

- [X] T025 [P] [US2] Test 3-word sentence "foo bar baz" in test/generator_test.rb - verify N=1 (3 lines) and N=2 (2 lines) only
- [X] T026 [P] [US2] Test 5-word sentence "one two three four five" in test/generator_test.rb - verify N=1 (5 lines), N=2 (2 lines), N=3 (3 lines)
- [X] T027 [P] [US2] Test 6-word sentence in test/generator_test.rb - verify max_chunk_size is 3 (ceil(6/2))
- [X] T028 [P] [US2] Test edge case with 1-word sentence in test/generator_test.rb - verify only N=1 with 1 cloze line
- [X] T029 [P] [US2] Test edge case with 2-word sentence in test/generator_test.rb - verify N=1 (2 lines) and N=2 (1 line)

### Implementation for User Story 2

- [X] T030 [US2] Extend generate_arrangements in lib/anki_cloze/cloze_set.rb to handle arbitrary N values (generalize algorithm)
- [X] T031 [US2] Implement recursive arrangement generation algorithm in lib/anki_cloze/cloze_set.rb for N>2 cases
- [X] T032 [US2] Add validation in lib/anki_cloze/generator.rb to handle edge cases (1-word, 2-word sentences)
- [X] T033 [US2] Optimize arrangement generation in lib/anki_cloze/cloze_set.rb for performance with longer sentences (up to 20 words)
- [X] T034 [US2] Add comprehensive integration test in test/integration_test.rb covering 3, 4, 5, 6, and 10-word sentences

**Checkpoint**: At this point, User Stories 1 AND 2 should both work - system handles any sentence length correctly

---

## Phase 5: User Story 3 - Handle Punctuation in Multi-Word Clozes (Priority: P3)

**Goal**: Correctly preserve punctuation (apostrophes, hyphens, commas) within multi-word cloze chunks

**Independent Test**: Provide "It's a well-known fact" and verify apostrophes and hyphens are preserved within cloze deletions

### Tests for User Story 3 ⚠️

- [X] T035 [P] [US3] Test contraction handling "It's raining" in test/sentence_test.rb - verify "It's" is single word
- [X] T036 [P] [US3] Test hyphenated word "well-known fact" in test/sentence_test.rb - verify "well-known" is single word
- [X] T037 [P] [US3] Test comma preservation "First, we analyze" in test/generator_test.rb - verify comma stays within cloze chunk
- [X] T038 [P] [US3] Test multiple punctuation types in test/integration_test.rb - verify "It's a well-known fact, honestly" handles all punctuation correctly

### Implementation for User Story 3

- [X] T039 [US3] Verify word splitting regex in lib/anki_cloze/sentence.rb preserves contractions and hyphens (should already work with \s+ split)
- [X] T040 [US3] Add test case documentation in test/sentence_test.rb for punctuation edge cases (trailing commas, periods, etc.)
- [X] T041 [US3] Verify Anki format output in lib/anki_cloze/formatter.rb doesn't escape or modify punctuation within chunks
- [X] T042 [US3] Add comprehensive punctuation test suite in test/integration_test.rb covering quotes, parentheses, semicolons

**Checkpoint**: All user stories should now be independently functional - system handles real-world text with punctuation

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories and final validation

- [X] T043 [P] Add usage help text to bin/anki-cloze CLI using OptionParser (--help, --version flags)
- [X] T044 [P] Document test-first workflow in test/test_helper.rb with comments on running tests
- [X] T045 Create comprehensive CLI integration test in test/cli_test.rb for stdin/stdout/stderr/exit codes
- [X] T046 Test quickstart.md scenarios - verify all examples produce expected output
- [X] T047 [P] Add performance test in test/performance_test.rb - verify 20-word sentence completes in <100ms
- [X] T048 [P] Code cleanup and refactoring - ensure all classes follow single responsibility principle
- [X] T049 Verify constitution compliance - confirm no external dependencies, CLI-first, test coverage complete
- [X] T050 Final validation run - execute all tests with verbose output and verify 100% pass rate

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-5)**: All depend on Foundational phase completion
  - User Story 1 (P1): MUST complete first - establishes core generation logic
  - User Story 2 (P2): Extends User Story 1 - depends on T021 (generate method framework)
  - User Story 3 (P3): Can proceed after User Story 1 - primarily validation of existing word splitting
- **Polish (Phase 6)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Depends on User Story 1 core implementation (specifically T018-T021) - Extends the arrangement generation algorithm
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - Minimal dependencies, mostly validates existing word splitting logic

### Within Each User Story (Test-First Workflow)

- Tests MUST be written FIRST and FAIL before implementation begins
- For User Story 1: Write all tests T011-T014 before implementing T015-T024
- For User Story 2: Write all tests T025-T029 before implementing T030-T034
- For User Story 3: Write all tests T035-T038 before implementing T039-T042
- Run tests after each implementation task to verify green status
- Models/data structures before services/logic
- Core implementation before integration

### Parallel Opportunities

**Within Setup (Phase 1)**:
- T003 (CLI script) and T004 (Rakefile) can run in parallel after T001-T002

**Within Foundational (Phase 2)**:
- T007 (Chunk tests) and T009 (Formatter tests) can run in parallel after T005
- T008 (Chunk impl) and T010 (Formatter impl) can run in parallel after T006

**Within User Story 1 Tests**:
- All test files T011-T014 can be written in parallel (different test files)

**Within User Story 1 Implementation**:
- T015 (Arrangement class) can run in parallel with T017 (ClozeSet class)

**Within User Story 2 Tests**:
- All test cases T025-T029 can be written in parallel (same test file, different methods)

**Within User Story 3 Tests**:
- All test cases T035-T038 can be written in parallel (different aspects of punctuation)

**Within Polish Phase**:
- T043 (help text), T044 (docs), T047 (performance), T048 (cleanup) can all run in parallel

---

## Parallel Example: User Story 1

```bash
# STEP 1: Write all tests FIRST (in parallel)
Task T011: "Contract test for single-word cloze generation (N=1) in test/generator_test.rb"
Task T012: "Contract test for two-word cloze generation (N=2) in test/generator_test.rb"
Task T013: "Integration test for complete cloze set generation in test/integration_test.rb"
Task T014: "Test for max_chunk_size calculation in test/cloze_set_test.rb"

# STEP 2: Run tests - verify they FAIL (red)
ruby -Ilib:test test/*_test.rb
# Expected: All new tests fail because classes don't exist yet

# STEP 3: Implement in parallel where possible
Task T015: "Create lib/anki_cloze/arrangement.rb" (parallel with T017)
Task T017: "Create lib/anki_cloze/cloze_set.rb"

# STEP 4: Implement dependent tasks sequentially
Task T016: "Implement to_anki_format in arrangement.rb" (depends on T015)
Task T018: "Implement generate_arrangements for N=1" (depends on T017)
Task T019: "Extend generate_arrangements for N=2" (depends on T018)

# STEP 5: Integration tasks (sequential)
Task T020-T024: Wire up and test

# STEP 6: Run tests - verify they PASS (green)
ruby -Ilib:test test/*_test.rb
# Expected: All tests pass
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001-T004)
2. Complete Phase 2: Foundational (T005-T010) - CRITICAL
3. Complete Phase 3: User Story 1 (T011-T024) following TDD
   - Write ALL tests first (T011-T014)
   - Verify tests fail (RED)
   - Implement minimum code (T015-T024)
   - Verify tests pass (GREEN)
   - Refactor as needed
4. **STOP and VALIDATE**: Test User Story 1 independently with quickstart examples
5. Ready for real-world use with basic multi-word cloze generation

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready (T001-T010)
2. Add User Story 1 → Test independently → Deploy/Demo (T011-T024) **MVP!**
   - Can generate clozes for any 4-word sentence
   - Handles N=1 and N=2 chunk sizes
3. Add User Story 2 → Test independently → Deploy/Demo (T025-T034)
   - Now handles any sentence length (3-20 words)
   - Automatically calculates max chunk size
4. Add User Story 3 → Test independently → Deploy/Demo (T035-T042)
   - Now handles real-world text with punctuation
   - Production-ready for actual content
5. Polish → Final validation → Production release (T043-T050)

### Test-First Development Workflow

**For EVERY implementation task**:
1. **RED**: Write test first, run it, verify it fails
2. **GREEN**: Write minimum code to make test pass
3. **REFACTOR**: Clean up code while keeping tests green
4. **COMMIT**: Save progress after each green cycle

**Example for Task T018** (Implement generate_arrangements for N=1):
```bash
# RED Phase
$ ruby -Ilib:test test/generator_test.rb
# Test fails: "undefined method `generate_arrangements`"

# GREEN Phase
# Implement minimum code in lib/anki_cloze/cloze_set.rb
$ ruby -Ilib:test test/generator_test.rb
# Test passes: "1 runs, 5 assertions, 0 failures"

# REFACTOR Phase
# Clean up variable names, extract methods if needed
$ ruby -Ilib:test test/generator_test.rb
# Still passes: "1 runs, 5 assertions, 0 failures"

# COMMIT
$ git add lib/anki_cloze/cloze_set.rb test/generator_test.rb
$ git commit -m "Implement N=1 arrangement generation with tests"
```

---

## Notes

- **[P]** tasks = different files, no dependencies - can run in parallel
- **[Story]** label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- **TEST-FIRST CRITICAL**: Write tests BEFORE implementation for every feature
- Verify tests fail before implementing (RED phase)
- Implement minimum code to pass tests (GREEN phase)
- Refactor while keeping tests green
- Commit after each RED-GREEN-REFACTOR cycle
- Stop at any checkpoint to validate story independently
- Follow quickstart.md examples to verify real-world usage
- Constitution compliance: no external dependencies, CLI-first, 100% test coverage
