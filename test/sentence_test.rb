# frozen_string_literal: true

require_relative "test_helper"

class SentenceTest < Minitest::Test
  def test_initializes_with_text
    sentence = AnkiCloze::Sentence.new("The quick brown fox")
    assert_equal "The quick brown fox", sentence.text
  end

  def test_splits_text_into_words
    sentence = AnkiCloze::Sentence.new("The quick brown fox")
    assert_equal ["The", "quick", "brown", "fox"], sentence.words
  end

  def test_counts_words
    sentence = AnkiCloze::Sentence.new("The quick brown fox")
    assert_equal 4, sentence.word_count
  end

  def test_handles_multiple_spaces
    sentence = AnkiCloze::Sentence.new("The  quick   brown")
    assert_equal ["The", "quick", "brown"], sentence.words
    assert_equal 3, sentence.word_count
  end

  def test_preserves_contractions
    sentence = AnkiCloze::Sentence.new("It's raining")
    assert_equal ["It's", "raining"], sentence.words
    assert_equal 2, sentence.word_count
  end

  def test_preserves_hyphens
    sentence = AnkiCloze::Sentence.new("well-known fact")
    assert_equal ["well-known", "fact"], sentence.words
    assert_equal 2, sentence.word_count
  end

  def test_rejects_empty_text
    error = assert_raises(ArgumentError) do
      AnkiCloze::Sentence.new("")
    end
    assert_match(/empty/i, error.message)
  end

  def test_rejects_whitespace_only
    error = assert_raises(ArgumentError) do
      AnkiCloze::Sentence.new("   ")
    end
    assert_match(/empty/i, error.message)
  end
end
