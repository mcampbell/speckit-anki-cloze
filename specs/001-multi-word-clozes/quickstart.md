# Quickstart: Multi-Word Cloze Generation

**Feature**: `001-multi-word-clozes`  
**Date**: 2026-01-11

## What This Feature Does

Automatically generates Anki cloze deletion flashcards from a plain text sentence. Creates all possible N-word cloze combinations from single words up to half the sentence length, helping you memorize content at multiple granularities.

---

## Installation & Setup

### Prerequisites
- Ruby 3.2 or later
- No external dependencies needed (uses stdlib only)

### Quick Setup
```bash
# Clone or navigate to repository
cd anki-cloze

# No installation needed - pure Ruby with stdlib
# Just make the CLI executable
chmod +x bin/anki-cloze
```

---

## Usage

### Basic Command
```bash
# Direct sentence input
bin/anki-cloze "The quick brown fox"

# Or use pipeline
echo "The quick brown fox" | bin/anki-cloze

# Or from file
bin/anki-cloze < sentences.txt
```

### Output
```text
{{c1::The}} quick brown fox
The {{c1::quick}} brown fox
The quick {{c1::brown}} fox
The quick brown {{c1::fox}}
{{c1::The quick}} {{c2::brown fox}}
```

Each line is a separate flashcard. Import directly into Anki.

---

## Common Scenarios

### Scenario 1: Memorize a Quote
**Goal**: Create flashcards for "Knowledge is power"

```bash
bin/anki-cloze "Knowledge is power"
```

**Output**:
```text
{{c1::Knowledge}} is power
Knowledge {{c1::is}} power
Knowledge is {{c1::power}}
{{c1::Knowledge is}} power
Knowledge {{c1::is power}}
```

**Result**: 5 flashcards - 3 testing individual words, 2 testing word pairs

---

### Scenario 2: Learn Technical Terms
**Goal**: Memorize "Ruby's object-oriented programming paradigm"

```bash
bin/anki-cloze "Ruby's object-oriented programming paradigm"
```

**Output**: 7 flashcards total
- 4 cards with single-word clozes (N=1)
- 3 cards with two-word phrase clozes (N=2)

**Note**: Hyphenated words like "object-oriented" are treated as single units

---

### Scenario 3: Batch Processing
**Goal**: Generate clozes for multiple sentences

```bash
# Create input file
cat > sentences.txt << EOF
The mitochondria generates ATP
Photosynthesis occurs in chloroplasts
DNA contains genetic information
EOF

# Process each line
while read -r line; do
  echo "=== $line ==="
  bin/anki-cloze "$line"
  echo
done < sentences.txt > flashcards.txt
```

---

## Understanding the Output

### Chunk Sizes (N)
For a W-word sentence, the tool generates clozes for:
- N = 1 (individual words)
- N = 2 (word pairs)
- ...
- N = ceil(W/2) (half the sentence)

**Examples**:
- 3 words → N=1 and N=2
- 4 words → N=1 and N=2
- 5 words → N=1, N=2, and N=3
- 6 words → N=1, N=2, and N=3

### Anki Format
- `{{c1::text}}` - Anki cloze deletion syntax
- Multiple clozes on same line use incrementing numbers: `{{c1::...}}`, `{{c2::...}}`, etc.
- One line = one flashcard

---

## Test-First Development Workflow

### Running Tests
```bash
# Run all tests
ruby -Ilib:test test/*_test.rb

# Run specific test file
ruby -Ilib:test test/generator_test.rb

# Run with verbose output
ruby -Ilib:test test/*_test.rb --verbose
```

### Writing New Tests
Following TDD (Red-Green-Refactor):

**1. Red - Write failing test**
```ruby
# test/generator_test.rb
def test_generates_single_word_clozes
  sentence = "The quick brown fox"
  generator = AnkiCloze::Generator.new(sentence)
  
  result = generator.generate_clozes(chunk_size: 1)
  
  assert_equal 4, result.length
  assert_includes result, "{{c1::The}} quick brown fox"
end
```

**2. Green - Implement minimum code**
```ruby
# lib/anki_cloze/generator.rb
module AnkiCloze
  class Generator
    def initialize(sentence)
      @sentence = sentence
      @words = sentence.split(/\s+/)
    end
    
    def generate_clozes(chunk_size:)
      # Minimum implementation to pass test
    end
  end
end
```

**3. Refactor - Clean up while keeping tests green**

### Test Structure
```text
test/
├── test_helper.rb          # Minitest setup
├── generator_test.rb       # Core generation logic tests
├── formatter_test.rb       # Anki format output tests
└── integration_test.rb     # End-to-end CLI tests
```

---

## Troubleshooting

### Issue: Empty Output
**Symptom**: Command runs but produces no output

**Check**:
```bash
# Verify input has content
echo "test" | bin/anki-cloze

# Check for errors
echo "test" | bin/anki-cloze 2>&1
```

**Solution**: Ensure input sentence is not empty or only whitespace

---

### Issue: Unexpected Word Splitting
**Symptom**: Contractions or hyphenated words split incorrectly

**Example**:
```bash
# Correct: "don't" is one word
bin/anki-cloze "I don't know"
# Should show "don't" as single unit

# Correct: "well-known" is one word
bin/anki-cloze "A well-known fact"
# Should keep "well-known" together
```

**Note**: This is expected behavior per specification

---

### Issue: Test Failures
**Symptom**: Tests fail after changes

**Debug Steps**:
```bash
# Run tests with verbose output
ruby -Ilib:test test/*_test.rb --verbose

# Run single test method
ruby -Ilib:test test/generator_test.rb --name test_specific_method

# Add debugging output in test
def test_something
  result = generator.generate
  puts "DEBUG: result = #{result.inspect}"
  assert_equal expected, result
end
```

---

## Next Steps

### For Users
1. Generate clozes for your learning material
2. Import output into Anki
3. Start reviewing flashcards

### For Developers
1. Review test suite in `test/` directory
2. Follow TDD workflow: write test first, then implement
3. Check constitution compliance: no external dependencies, CLI-first, test coverage

### Importing to Anki
1. Copy output to a text file
2. In Anki: File → Import
3. Select "Cloze" note type
4. Map fields appropriately
5. Import and review!

---

## Reference

- **Feature Spec**: `specs/001-multi-word-clozes/spec.md`
- **Implementation Plan**: `specs/001-multi-word-clozes/plan.md`
- **Research**: `specs/001-multi-word-clozes/research.md`
- **Data Model**: `specs/001-multi-word-clozes/data-model.md`
- **CLI Contract**: `specs/001-multi-word-clozes/contracts/cli-contract.md`
- **Constitution**: `.specify/memory/constitution.md`

## Support

For issues or questions:
1. Check this quickstart guide
2. Review the CLI contract for detailed specifications
3. Run tests to verify expected behavior
4. Check constitution for development principles
