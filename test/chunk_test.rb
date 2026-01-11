# frozen_string_literal: true

require_relative "test_helper"

class ChunkTest < Minitest::Test
  def test_initializes_with_attributes
    chunk = AnkiCloze::Chunk.new(start_index: 0, size: 2, words: ["The", "quick"])
    assert_equal 0, chunk.start_index
    assert_equal 2, chunk.size
    assert_equal ["The", "quick"], chunk.words
  end

  def test_converts_to_string
    chunk = AnkiCloze::Chunk.new(start_index: 0, size: 2, words: ["The", "quick"])
    assert_equal "The quick", chunk.to_s
  end

  def test_calculates_end_index
    chunk = AnkiCloze::Chunk.new(start_index: 0, size: 2, words: ["The", "quick"])
    assert_equal 1, chunk.end_index
  end

  def test_single_word_chunk
    chunk = AnkiCloze::Chunk.new(start_index: 2, size: 1, words: ["brown"])
    assert_equal "brown", chunk.to_s
    assert_equal 2, chunk.end_index
  end

  def test_handles_punctuation_in_words
    chunk = AnkiCloze::Chunk.new(start_index: 0, size: 2, words: ["It's", "raining"])
    assert_equal "It's raining", chunk.to_s
  end
end
