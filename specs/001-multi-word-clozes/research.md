# Research: Multi-Word Cloze Generation

**Branch**: `001-multi-word-clozes` | **Date**: 2026-01-11

## Phase 0: Research Findings

### 1. Combinatorial Generation Algorithm

**Decision**: Use recursive/iterative approach to generate all non-overlapping N-word chunk arrangements

**Rationale**: 
- For a sentence with W words and chunk size N, we need to partition the sentence into ceil(W/N) chunks
- Each arrangement represents a different way to group consecutive words into N-sized chunks
- Algorithm needs to handle partial chunks (when W is not divisible by N)
- Implementation approach: sliding window to identify all possible starting positions, then generate valid non-overlapping arrangements

**Alternatives Considered**:
1. Brute force permutation generation - Rejected: Would include overlapping chunks and invalid arrangements
2. Mathematical formula-based generation - Rejected: Complex to implement for variable word counts and chunk sizes
3. Iterative partition generation - Selected: Clear, testable, and efficient for our scale (max 20 words)

**Key Insights**:
- For N=1 with 4 words: Generate 4 cards (one cloze each)
- For N=2 with 4 words: Generate 1 card with 2 non-overlapping clozes: {{c1::word1 word2}} {{c2::word3 word4}}
- For N=2 with 5 words: Generate 2 arrangements:
  - {{c1::word1 word2}} {{c2::word3 word4}} word5
  - word1 {{c1::word2 word3}} {{c2::word4 word5}}
- Pattern: For chunk size N, there are (W - N + 1) possible starting positions for first chunk

### 2. Ruby Test-First Development with Minitest

**Decision**: Use Minitest (Ruby stdlib) with test-first TDD workflow

**Rationale**:
- Minitest is included in Ruby standard library (aligns with Simplicity principle)
- Simple, fast, and well-documented
- Supports both test/unit style and spec style
- Built-in assertions cover all needs for this project
- No external dependencies required

**Best Practices**:
1. **File Structure**: Place tests in `test/` directory with `_test.rb` suffix
2. **Test Helper**: Create `test/test_helper.rb` to configure Minitest and load dependencies
3. **Naming Convention**: Test methods start with `test_` prefix
4. **Assertions**: Use clear assertion methods (assert_equal, assert_includes, refute_nil)
5. **Test Organization**: One test file per class, organize tests by behavior/scenario
6. **Run Tests**: `ruby -Ilib:test test/*_test.rb` or use Rake task

**Example Structure**:
```ruby
# test/test_helper.rb
require 'minitest/autorun'
require_relative '../lib/anki_cloze/generator'

# test/generator_test.rb
require_relative 'test_helper'

class GeneratorTest < Minitest::Test
  def test_single_word_cloze_generation
    # Red-Green-Refactor cycle starts here
  end
end
```

**Alternatives Considered**:
1. RSpec - Rejected: External dependency, more complex than needed
2. Test::Unit - Rejected: Minitest is the modern stdlib replacement
3. No testing framework - Rejected: Violates Test-First principle

### 3. CLI Design for Ruby

**Decision**: Use Ruby's OptionParser (stdlib) for argument parsing, accept stdin and args

**Rationale**:
- OptionParser provides robust CLI parsing without external dependencies
- Supports both short and long options
- Automatic help text generation
- stdin reading allows pipeline usage: `echo "sentence" | anki-cloze`
- Argument reading allows direct usage: `anki-cloze "sentence"`

**Interface Design**:
```bash
# Usage patterns
anki-cloze "The quick brown fox"           # Direct argument
echo "The quick brown fox" | anki-cloze    # Pipeline input
anki-cloze < input.txt                      # File redirect

# Output to stdout (one arrangement per line)
{{c1::The}} quick brown fox
The {{c1::quick}} brown fox
The quick {{c1::brown}} fox
...
```

**Best Practices**:
1. Check ARGV first, then fall back to STDIN if empty
2. Exit with status 0 on success, 1 on error
3. Write errors to STDERR
4. Make bin/ script executable with shebang: `#!/usr/bin/env ruby`
5. Keep main script minimal - delegate to lib/ classes

**Alternatives Considered**:
1. Thor - Rejected: External dependency for simple CLI
2. GLI - Rejected: Over-engineered for single command
3. Custom parsing - Rejected: OptionParser is stdlib and sufficient

### 4. Anki Cloze Format Specification

**Decision**: Output format uses incrementing `{{cN::text}}` for each cloze on a line

**Rationale**:
- Anki's cloze deletion format uses `{{cN::text}}` where N is the cloze number
- Multiple clozes on same line use incrementing numbers (c1, c2, c3...) so they are tested separately
- Each output line represents a different flashcard/arrangement
- Format is validated by Anki import - must be exact

**Format Rules**:
1. Clozes on a line use incrementing numbers: `{{c1::...}}`, `{{c2::...}}`, etc.
2. Preserve exact spacing and punctuation from input
3. No extra whitespace around `::` or within braces
4. Words within multi-word cloze separated by original spacing

**Example**:
```text
Input: "The quick brown fox"
Output line: "{{c1::The quick}} {{c2::brown fox}}"
NOT: "{{ c1 :: The quick }} {{ c2 :: brown fox }}"  # Wrong spacing
NOT: "{{c1::The  quick}}"                            # Wrong internal spacing
```

**Alternatives Considered**:
1. Same numbering (c1, c1, c1) - Rejected: All clozes appear together, not tested separately
2. JSON output - Rejected: Not requested, adds complexity
3. Custom format - Rejected: Must match Anki's exact format for import

### 5. Word Boundary Detection

**Decision**: Use Ruby regex `\S+` to split on whitespace, treating contractions and hyphens as single units

**Rationale**:
- Simple whitespace splitting naturally handles contractions (don't) and hyphens (well-known) as single words
- Regex `\S+` captures any non-whitespace sequence as a word
- Preserves all punctuation within words
- Aligns with spec requirement: contractions and hyphenated terms are single words

**Implementation**:
```ruby
words = sentence.split(/\s+/)  # or sentence.scan(/\S+/)
# "It's a well-known fact" => ["It's", "a", "well-known", "fact"]
```

**Edge Cases Handled**:
- Multiple spaces between words: normalize or preserve? → Preserve original spacing in output
- Leading/trailing whitespace: strip before processing
- Punctuation at word boundaries: "word," → Keep as single unit

**Alternatives Considered**:
1. Unicode word boundaries - Rejected: Overkill for English text, adds complexity
2. Custom tokenizer - Rejected: Not needed per spec clarifications
3. Split on specific characters - Rejected: Whitespace split is simpler and sufficient

## Research Summary

All technical unknowns resolved:
- ✅ Combinatorial algorithm for non-overlapping chunk generation
- ✅ Ruby Minitest setup for test-first development
- ✅ CLI design using OptionParser (stdlib)
- ✅ Anki format specification with exact syntax
- ✅ Word boundary detection using whitespace splitting

Ready to proceed to Phase 1: Design & Contracts.
