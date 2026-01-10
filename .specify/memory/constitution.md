<!--
SYNC IMPACT REPORT
==================
Version change: 0.0.0 → 1.0.0 (initial ratification)

Modified principles: N/A (initial version)

Added sections:
- Core Principles (3 principles: Simplicity, CLI-First, Test-First)
- Development Workflow
- Quality Gates
- Governance

Removed sections: N/A (initial version)

Templates requiring updates:
- .specify/templates/plan-template.md ✅ (compatible - Constitution Check section exists)
- .specify/templates/spec-template.md ✅ (compatible - user stories align with Test-First)
- .specify/templates/tasks-template.md ✅ (compatible - TDD workflow supported)

Follow-up TODOs: None
==================
-->

# Anki Cloze Constitution

## Core Principles

### I. Simplicity (YAGNI)

Start with the simplest solution that works. Avoid premature optimization and unnecessary
abstraction. Features MUST solve an immediate, concrete need.

- **Minimal Dependencies**: Add dependencies only when they provide clear, measurable value
- **No Speculative Features**: Do not build for hypothetical future requirements
- **Flat Over Nested**: Prefer flat data structures and simple control flow over deep nesting
- **Delete Before Abstract**: Remove unused code rather than abstracting "for later"

**Rationale**: Complexity is the primary source of bugs and maintenance burden. Every line of
code is a liability. The right amount of complexity is the minimum needed for the current task.

### II. CLI-First Interface

Every feature MUST be accessible via command-line interface with a text-based I/O protocol.

- **Input**: Accept input via stdin and/or command-line arguments
- **Output**: Write results to stdout; errors and diagnostics to stderr
- **Formats**: Support both human-readable and JSON output formats
- **Exit Codes**: Use standard exit codes (0 = success, non-zero = failure with specific codes)
- **Pipeable**: Design commands to work in Unix pipelines

**Rationale**: CLI interfaces are composable, scriptable, testable, and accessible. They enable
automation, integration with other tools, and provide a stable contract for programmatic use.

### III. Test-First Development

Tests MUST be written before implementation. The Red-Green-Refactor cycle is mandatory.

- **Red**: Write a failing test that defines the expected behavior
- **Green**: Write the minimum code to make the test pass
- **Refactor**: Clean up the code while keeping tests green
- **Coverage**: All public interfaces MUST have test coverage
- **No Untested Features**: Code without tests MUST NOT be merged

**Rationale**: Tests document intent, catch regressions early, and enable confident refactoring.
Writing tests first ensures testable design and prevents scope creep.

## Development Workflow

Code changes follow this sequence:

1. **Specify**: Document the feature requirements and acceptance criteria
2. **Plan**: Design the implementation approach and identify affected components
3. **Test**: Write failing tests that capture the requirements
4. **Implement**: Write the minimum code to pass tests
5. **Refactor**: Improve code quality while maintaining green tests
6. **Review**: Verify compliance with constitution principles

## Quality Gates

All changes MUST pass these gates before merge:

- **Tests Pass**: All existing and new tests MUST pass
- **Simplicity Check**: No unnecessary complexity, abstractions, or dependencies added
- **CLI Contract**: New features expose CLI interface per Principle II
- **Documentation**: User-facing changes include updated help text and examples

## Governance

This constitution supersedes all other development practices for the Anki Cloze project.

**Amendment Process**:
1. Propose amendment with rationale
2. Document impact on existing code and workflows
3. Update all affected templates and documentation
4. Increment version according to semantic versioning

**Versioning Policy**:
- **MAJOR**: Principle removal or backward-incompatible redefinition
- **MINOR**: New principle or section added, material guidance expansion
- **PATCH**: Clarifications, wording improvements, typo fixes

**Compliance**: All pull requests and code reviews MUST verify adherence to these principles.
Violations require explicit justification documented in the Complexity Tracking section of the
implementation plan.

**Version**: 1.0.0 | **Ratified**: 2026-01-10 | **Last Amended**: 2026-01-10
