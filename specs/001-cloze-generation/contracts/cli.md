# CLI Contract: anki-cloze

**Feature**: 001-cloze-generation
**Date**: 2026-01-10

## Command

```
anki-cloze [TEXT]
```

## Synopsis

Convert text to Anki cloze deletion format. Each word becomes a numbered cloze deletion.

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| TEXT | No | Text to convert. If omitted, reads from stdin. |

## Input Sources (Priority Order)

1. **Command-line argument**: `anki-cloze "A fool and his money"`
2. **Standard input (stdin)**: `echo "A fool and his money" | anki-cloze`

If both are provided, command-line argument takes precedence.

## Output

### Success (stdout)

Transformed text with each word wrapped in Anki cloze syntax.

```
{{c1::word1}} {{c2::word2}} {{c3::word3}} ...
```

### Errors (stderr)

Human-readable error message describing the problem.

```
Error: <description>
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error (invalid input, runtime error) |

## Examples

### Basic Usage

```bash
$ anki-cloze "A fool and his money"
{{c1::A}} {{c2::fool}} {{c3::and}} {{c4::his}} {{c5::money}}
```

### Piped Input

```bash
$ echo "Hello world" | anki-cloze
{{c1::Hello}} {{c2::world}}
```

### File Input

```bash
$ anki-cloze < sentence.txt
{{c1::The}} {{c2::quick}} {{c3::brown}} {{c4::fox}}
```

### Empty Input

```bash
$ anki-cloze ""
# (empty output)
$ echo $?
0
```

### Pipeline Usage

```bash
$ cat sentences.txt | while read line; do anki-cloze "$line"; done
```

## Encoding

- Input: UTF-8
- Output: UTF-8

## Limitations

- Single-line processing only (newlines in input not supported in MVP)
- No escape sequences for special characters
- No hint syntax support (Anki's `{{cN::text::hint}}` format)
