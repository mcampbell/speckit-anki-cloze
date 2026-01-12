# frozen_string_literal: true

require_relative "test_helper"

class ClozeSetTest < Minitest::Test
  # T014: Test for max_chunk_size calculation with various word counts
  def test_max_chunk_size_calculation
    # Already tested in GeneratorTest, but adding specific ClozeSet tests
    
    sentence3 = AnkiCloze::Sentence.new("one two three")
    cloze_set = AnkiCloze::ClozeSet.new(sentence3, 1)
    assert_equal 1, cloze_set.chunk_size
    
    sentence5 = AnkiCloze::Sentence.new("one two three four five")
    # For 5 words, max chunk size should be ceil(5/2) = 3
    # So we can create ClozeSet with chunk_size up to 3
    cloze_set1 = AnkiCloze::ClozeSet.new(sentence5, 1)
    assert_equal 1, cloze_set1.chunk_size
    
    cloze_set2 = AnkiCloze::ClozeSet.new(sentence5, 2)
    assert_equal 2, cloze_set2.chunk_size
    
    cloze_set3 = AnkiCloze::ClozeSet.new(sentence5, 3)
    assert_equal 3, cloze_set3.chunk_size
  end

  def test_generates_arrangements_for_n1
    sentence = AnkiCloze::Sentence.new("The quick brown fox")
    cloze_set = AnkiCloze::ClozeSet.new(sentence, 1)
    cloze_set.generate_arrangements
    
    # For N=1, should generate 1 arrangement with 4 chunks
    assert_equal 1, cloze_set.arrangements.length
    assert_equal 4, cloze_set.arrangements.first.chunks.length
  end

  def test_generates_arrangements_for_n2
    sentence = AnkiCloze::Sentence.new("The quick brown fox")
    cloze_set = AnkiCloze::ClozeSet.new(sentence, 2)
    cloze_set.generate_arrangements
    
    # For N=2 with 4 words, should generate 1 arrangement
    assert_equal 1, cloze_set.arrangements.length
  end
end
