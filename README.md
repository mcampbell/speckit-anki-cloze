# Anki Cloze Generator

A Ruby command-line tool that generates multi-word Anki cloze deletion flashcards
from sentences. This tool creates all possible N-word cloze patterns to help you
create comprehensive flashcard decks for spaced repetition learning.

## What It Does

The Anki Cloze Generator takes a sentence and produces multiple cloze deletion
variations with different chunk sizes. For example, given the sentence "The quick
brown fox", it generates:

- **Single-word clozes** (N=1):
  - `{{c1::The}} {{c2::quick}} {{c3::brown}} {{c4::fox}}`

- **Two-word clozes** (N=2):
  - `{{c1::The quick}} {{c2::brown fox}}`

The tool automatically calculates the maximum chunk size as `ceil(word_count/2)`
and generates all non-overlapping arrangements for each chunk size from 1 to the
maximum.

## Installation

### Prerequisites

- Ruby 3.2 or higher

### Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd anki-cloze
   ```

2. Make the executable available:
   ```bash
   chmod +x bin/anki-cloze
   ```

3. (Optional) Add to your PATH or create a symlink:
   ```bash
   # Example: link to /usr/local/bin
   ln -s $(pwd)/bin/anki-cloze /usr/local/bin/anki-cloze
   ```

## Usage

### Basic Usage

Generate cloze deletions from a sentence:

```bash
anki-cloze "The quick brown fox"
```

### Input Options

**Command-line argument:**
```bash
anki-cloze "Your sentence here"
```

**Standard input (stdin):**
```bash
echo "Your sentence here" | anki-cloze
```

**File input:**
```bash
anki-cloze < input.txt
```

### Command-Line Options

#### `-m, --minimum X`
Specify the minimum chunk size to emit (must be ≥ 1).

```bash
# Only generate 2-word and 3-word clozes
anki-cloze -m 2 "The quick brown fox jumps"
```

#### `-x, --maximum X`
Specify the maximum chunk size to emit (must be ≥ 1).

```bash
# Only generate single-word clozes
anki-cloze -x 1 "The quick brown fox"
```

#### Combining Options
Use both minimum and maximum to create a specific range:

```bash
# Only generate 2-word clozes
anki-cloze -m 2 -x 2 "one two three four"
```

Output:
```
{{c1::one two}} {{c2::three four}}
```

#### `-h, --help`
Display help information:

```bash
anki-cloze --help
```

## Examples

### Example 1: Default Behavior
```bash
anki-cloze "Learning is fun"
```

Output:
```
{{c1::Learning}} {{c2::is}} {{c3::fun}}
{{c1::Learning is}} fun
Learning {{c1::is fun}}
```

### Example 2: Only Multi-Word Clozes
```bash
anki-cloze -m 2 "Practice makes perfect sense now"
```

Output:
```
{{c1::Practice makes}} {{c2::perfect sense}} now
Practice {{c1::makes perfect}} {{c2::sense now}}
{{c1::Practice makes perfect}} sense now
Practice {{c1::makes perfect sense}} now
Practice makes {{c1::perfect sense now}}
```

### Example 3: Only Single-Word Clozes
```bash
anki-cloze -x 1 "Short and sweet"
```

Output:
```
{{c1::Short}} {{c2::and}} {{c3::sweet}}
```

### Example 4: Processing Multiple Sentences
```bash
cat sentences.txt | while read line; do
  echo "=== $line ==="
  anki-cloze "$line"
  echo
done
```

## Testing

Run the test suite:

```bash
rake test
```

All 67 tests should pass with 247 assertions.

## Architecture

The tool is built with a modular architecture:

- **Sentence**: Parses and validates input text
- **Chunk**: Represents a contiguous sequence of N words
- **Arrangement**: A specific pattern of non-overlapping chunks
- **ClozeSet**: Collection of all arrangements for a given chunk size
- **Formatter**: Converts arrangements to Anki cloze syntax
- **Generator**: Orchestrates the entire generation process

All classes and methods include comprehensive YARD documentation.

## Use Cases

- **Language Learning**: Create flashcards for vocabulary and phrases
- **Medical/Legal Studies**: Memorize complex terminology and definitions
- **Programming**: Learn syntax patterns and code snippets
- **General Knowledge**: Create study materials for any subject

## Anki Import

To import the generated cloze deletions into Anki:

1. Generate your clozes and save to a file:
   ```bash
   anki-cloze "Your sentence" > clozes.txt
   ```

2. In Anki, create cards using the "Cloze" note type
3. Paste the generated text into the "Text" field
4. Anki will automatically recognize the `{{c1::...}}` syntax

## Contributing

Contributions are welcome! Please ensure all tests pass before submitting pull
requests.

## License

Apache License 2.0

## Author

Michael Campbell <michael.campbell@gmail.com>

Note that most of this was written with Claude Code's Sonnet 4.5 model; this 
was mostly an experiment of using AI with GitHub [`spec-kit`](https://github.com/mcampbell/spec-kit).
