# Data Model: Basic Cloze Generation

**Feature**: 001-cloze-generation
**Date**: 2026-01-10

## Overview

This feature performs stateless text transformation. No persistent data storage is required.
The data model describes the in-memory structures used during transformation.

## Entities

### ClozeItem

Represents a single word converted to cloze format.

| Field | Type | Description |
|-------|------|-------------|
| number | Integer | Sequential cloze number (1-based) |
| content | String | The word/text to be hidden |

**Validation Rules**:
- `number` must be positive integer (>= 1)
- `content` must be non-empty string

**Output Format**: `{{c{number}::{content}}}`

### Input

Raw text received from stdin or command-line argument.

| Field | Type | Description |
|-------|------|-------------|
| text | String | Raw input text |
| source | Symbol | `:argv` or `:stdin` |

**Validation Rules**:
- `text` can be empty (produces empty output)
- `text` must be valid UTF-8

### Output

Transformed text with cloze deletions.

| Field | Type | Description |
|-------|------|-------------|
| text | String | Transformed text with cloze syntax |
| cloze_count | Integer | Number of cloze deletions created |

## Transformations

### Word → ClozeItem

```
Input:  "money"     (word at position 5)
Output: ClozeItem(number: 5, content: "money")
Format: "{{c5::money}}"
```

### Sentence → Output

```
Input:  "A fool and his money"
Split:  ["A", "fool", "and", "his", "money"]
Map:    [ClozeItem(1,"A"), ClozeItem(2,"fool"), ClozeItem(3,"and"),
         ClozeItem(4,"his"), ClozeItem(5,"money")]
Join:   "{{c1::A}} {{c2::fool}} {{c3::and}} {{c4::his}} {{c5::money}}"
```

## State Transitions

N/A - This is a stateless transformation. No state machine required.

## Relationships

```
Input (1) --transforms-to--> (1) Output
Input (1) --splits-into--> (N) ClozeItem
Output (1) --contains--> (N) ClozeItem
```
