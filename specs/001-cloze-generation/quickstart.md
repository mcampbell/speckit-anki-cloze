# Quickstart: Basic Cloze Generation

**Feature**: 001-cloze-generation
**Date**: 2026-01-10

## Prerequisites

- Ruby 3.2 or later

Check your Ruby version:

```bash
ruby --version
```

## Installation

Clone the repository and ensure the CLI is executable:

```bash
git clone <repository-url>
cd anki-cloze
chmod +x bin/anki-cloze
```

## Basic Usage

### Convert a sentence

```bash
./bin/anki-cloze "A fool and his money"
```

**Output**:

```
{{c1::A}} {{c2::fool}} {{c3::and}} {{c4::his}} {{c5::money}}
```

### Use with pipes

```bash
echo "The quick brown fox" | ./bin/anki-cloze
```

**Output**:

```
{{c1::The}} {{c2::quick}} {{c3::brown}} {{c4::fox}}
```

### Process a file

```bash
./bin/anki-cloze < my_sentence.txt
```

## Importing to Anki

1. Copy the output from `anki-cloze`
2. In Anki, create a new card with "Cloze" note type
3. Paste the output into the Text field
4. The card will automatically create separate review cards for each cloze deletion

## Running Tests

```bash
ruby -Ilib:test test/anki_cloze_test.rb
```

Or with Rake (if configured):

```bash
rake test
```

## Verification Checklist

After implementation, verify the following work correctly:

- [x] `./bin/anki-cloze "Hello world"` outputs `{{c1::Hello}} {{c2::world}}`
- [x] `echo "Test" | ./bin/anki-cloze` outputs `{{c1::Test}}`
- [x] `./bin/anki-cloze ""` produces empty output with exit code 0
- [x] Invalid scenarios write to stderr and exit with code 1
- [x] All tests pass: `ruby -Ilib:test test/anki_cloze_test.rb`
