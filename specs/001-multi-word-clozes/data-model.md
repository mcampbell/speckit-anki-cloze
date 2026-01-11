# Data Model: Multi-Word Cloze Generation

**Branch**: `001-multi-word-clozes` | **Date**: 2026-01-11

## Core Entities

### 1. Sentence
**Description**: The input text from which cloze cards are generated

**Attributes**:
- `text` (String): The raw input sentence
- `words` (Array<String>): Sentence split into word tokens
- `word_count` (Integer): Number of words in sentence

**Validation Rules**:
- Must not be empty or only whitespace
- Must contain at least 1 word after splitting

**Example**:
```ruby
Sentence.new("The quick brown fox")
# => words: ["The", "quick", "brown", "fox"]
# => word_count: 4
```

---

### 2. ChunkSize
**Description**: Represents the N-word size for cloze chunk generation

**Attributes**:
- `n` (Integer): The number of consecutive words in each chunk

**Validation Rules**:
- Must be >= 1
- Must be <= word_count of sentence

**Derived Values**:
- `max_chunk_size` for sentence: `ceil(word_count / 2.0)`

**Example**:
```ruby
# For 5-word sentence: max = ceil(5/2.0) = 3
# Valid chunk sizes: 1, 2, 3
```

---

### 3. Chunk
**Description**: A contiguous sequence of N consecutive words

**Attributes**:
- `start_index` (Integer): Starting word position (0-based)
- `size` (Integer): Number of words in chunk (N)
- `words` (Array<String>): The actual words in this chunk

**Methods**:
- `to_s`: Returns space-joined words
- `end_index`: Returns `start_index + size - 1`

**Example**:
```ruby
Chunk.new(start_index: 0, size: 2, words: ["The", "quick"])
# => "The quick"
# => end_index: 1
```

---

### 4. Arrangement
**Description**: A specific pattern of non-overlapping N-word chunks across the sentence

**Attributes**:
- `chunks` (Array<Chunk>): The cloze chunks in this arrangement
- `sentence` (Sentence): Reference to original sentence

**Validation Rules**:
- Chunks must not overlap (each word appears in at most one chunk)
- Chunks must be in order by start_index
- All chunks must have same size N

**Methods**:
- `to_anki_format`: Generates Anki cloze string with {{c1::text}} format

**Example**:
```ruby
# For "The quick brown fox" with N=2
# Arrangement 1: chunks at [0,1] and [2,3]
arrangement = Arrangement.new([
  Chunk.new(0, 2, ["The", "quick"]),
  Chunk.new(2, 2, ["brown", "fox"])
])
arrangement.to_anki_format
# => "{{c1::The quick}} {{c1::brown fox}}"
```

---

### 5. ClozeSet
**Description**: Complete collection of all arrangements for a given sentence and chunk size N

**Attributes**:
- `sentence` (Sentence): The source sentence
- `chunk_size` (Integer): The N value for this set
- `arrangements` (Array<Arrangement>): All valid non-overlapping arrangements

**Methods**:
- `generate_arrangements`: Produces all valid arrangement patterns
- `count`: Returns number of arrangements

**Example**:
```ruby
# For "The quick brown fox jumps" (5 words) with N=2
cloze_set = ClozeSet.new(sentence, 2)
cloze_set.arrangements.count # => 2
# Arrangement 1: [0-1, 2-3] leave word 4
# Arrangement 2: [1-2, 3-4] leave word 0
```

---

## Entity Relationships

```text
Sentence (1) ──< has many >── (N) ClozeSet
    │                              │
    │                              │
    └── provides words ──>         │
                                   │
                                   ├──< contains >── (N) Arrangement
                                                          │
                                                          │
                                                          └──< contains >── (N) Chunk
```

**Flow**:
1. Sentence is parsed into words
2. For each chunk_size (1 to max), create a ClozeSet
3. Each ClozeSet generates all valid Arrangements
4. Each Arrangement contains non-overlapping Chunks
5. Each Arrangement renders to Anki format

---

## State Transitions

### Sentence Processing Flow

```text
[User Input]
    ↓
[Raw Text] ──split/validate──> [Sentence]
    ↓
[Calculate max_chunk_size = ceil(words/2)]
    ↓
[For N = 1 to max_chunk_size]
    ↓
[Generate ClozeSet(N)] ──> [Generate all Arrangements]
    ↓
[For each Arrangement] ──> [Render to Anki format]
    ↓
[Output line to stdout]
```

**Validation Points**:
1. Input validation: Not empty, not only whitespace
2. Chunk size validation: 1 <= N <= ceil(word_count/2)
3. Arrangement validation: No overlapping chunks

---

## Data Examples

### Example 1: 4-word sentence
```ruby
sentence = "The quick brown fox"
word_count = 4
max_chunk_size = ceil(4/2.0) = 2

ClozeSet N=1: 4 arrangements (one per word)
  - {{c1::The}} quick brown fox
  - The {{c1::quick}} brown fox
  - The quick {{c1::brown}} fox
  - The quick brown {{c1::fox}}

ClozeSet N=2: 1 arrangement
  - {{c1::The quick}} {{c1::brown fox}}
```

### Example 2: 5-word sentence
```ruby
sentence = "one two three four five"
word_count = 5
max_chunk_size = ceil(5/2.0) = 3

ClozeSet N=1: 5 arrangements

ClozeSet N=2: 2 arrangements
  - {{c1::one two}} {{c1::three four}} five
  - one {{c1::two three}} {{c1::four five}}

ClozeSet N=3: 1 arrangement
  - {{c1::one two three}} four five
  (Note: only one way to fit 3-word chunk in 5 words without overlap)
```

### Example 3: Edge case with punctuation
```ruby
sentence = "It's a well-known fact"
words = ["It's", "a", "well-known", "fact"]
word_count = 4
max_chunk_size = 2

# Punctuation preserved within words
ClozeSet N=2, Arrangement 1:
  - {{c1::It's a}} {{c1::well-known fact}}
```

---

## Implementation Notes

**Immutability**: Consider making Sentence, Chunk, and Arrangement immutable (frozen) after creation to prevent accidental modification during generation.

**Performance**: For max 20 words and max chunk size of 10, total arrangements across all N values is manageable (<1000 lines). No optimization needed initially.

**Testing Strategy**: 
- Test each entity in isolation first
- Test relationship building (Sentence → ClozeSet → Arrangement)
- Test edge cases (1 word, 2 words, odd/even counts)
- Test format output separately from generation logic
