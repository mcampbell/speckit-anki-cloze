# frozen_string_literal: true

require_relative "test_helper"

class FormatterTest < Minitest::Test
  def test_formats_single_chunk_arrangement
    sentence = AnkiCloze::Sentence.new("The quick brown fox")
    chunk = AnkiCloze::Chunk.new(start_index: 0, size: 1, words: ["The"])
    arrangement = AnkiCloze::Arrangement.new(sentence: sentence, chunks: [chunk])
    
    result = AnkiCloze::Formatter.to_anki_format(arrangement)
    assert_equal "{{c1::The}} quick brown fox", result
  end

  def test_formats_multiple_chunks
    sentence = AnkiCloze::Sentence.new("The quick brown fox")
    chunks = [
      AnkiCloze::Chunk.new(start_index: 0, size: 2, words: ["The", "quick"]),
      AnkiCloze::Chunk.new(start_index: 2, size: 2, words: ["brown", "fox"])
    ]
    arrangement = AnkiCloze::Arrangement.new(sentence: sentence, chunks: chunks)
    
    result = AnkiCloze::Formatter.to_anki_format(arrangement)
    assert_equal "{{c1::The quick}} {{c1::brown fox}}", result
  end

  def test_formats_with_gaps
    sentence = AnkiCloze::Sentence.new("one two three four five")
    chunks = [
      AnkiCloze::Chunk.new(start_index: 0, size: 2, words: ["one", "two"]),
      AnkiCloze::Chunk.new(start_index: 2, size: 2, words: ["three", "four"])
    ]
    arrangement = AnkiCloze::Arrangement.new(sentence: sentence, chunks: chunks)
    
    result = AnkiCloze::Formatter.to_anki_format(arrangement)
    assert_equal "{{c1::one two}} {{c1::three four}} five", result
  end

  def test_preserves_punctuation
    sentence = AnkiCloze::Sentence.new("It's a well-known fact")
    chunks = [
      AnkiCloze::Chunk.new(start_index: 0, size: 2, words: ["It's", "a"]),
      AnkiCloze::Chunk.new(start_index: 2, size: 2, words: ["well-known", "fact"])
    ]
    arrangement = AnkiCloze::Arrangement.new(sentence: sentence, chunks: chunks)
    
    result = AnkiCloze::Formatter.to_anki_format(arrangement)
    assert_equal "{{c1::It's a}} {{c1::well-known fact}}", result
  end
end
