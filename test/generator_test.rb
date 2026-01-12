# frozen_string_literal: true

require_relative "test_helper"

class GeneratorTest < Minitest::Test
  # T011: Contract test for single-word cloze generation (N=1)
  def test_generates_single_word_clozes_for_four_word_sentence
    generator = AnkiCloze::Generator.new("The quick brown fox")
    result = generator.generate

    # Should produce 4 cloze lines for N=1 (single cloze marker per line)
    n1_lines = result.select { |line| line.scan(/\{\{c\d+::/).count == 1 }
    assert_equal 4, n1_lines.count

    # Verify each word gets cloze'd
    assert_includes result, "{{c1::The}} quick brown fox"
    assert_includes result, "The {{c1::quick}} brown fox"
    assert_includes result, "The quick {{c1::brown}} fox"
    assert_includes result, "The quick brown {{c1::fox}}"
  end

  # T012: Contract test for two-word cloze generation (N=2)
  def test_generates_two_word_clozes_for_four_word_sentence
    generator = AnkiCloze::Generator.new("The quick brown fox")
    result = generator.generate

    # Should produce 1 arrangement with 2 clozes for N=2
    n2_lines = result.select { |line| line.scan(/\{\{c\d+::/).count == 2 }
    assert_equal 1, n2_lines.count

    # Verify the arrangement (c1 and c2 for incrementing cloze numbers)
    assert_includes result, "{{c1::The quick}} {{c2::brown fox}}"
  end

  # T014: Test for max_chunk_size calculation
  def test_calculates_max_chunk_size
    generator3 = AnkiCloze::Generator.new("one two three")
    assert_equal 2, generator3.calculate_max_chunk_size # ceil(3/2) = 2
    
    generator4 = AnkiCloze::Generator.new("one two three four")
    assert_equal 2, generator4.calculate_max_chunk_size # ceil(4/2) = 2
    
    generator5 = AnkiCloze::Generator.new("one two three four five")
    assert_equal 3, generator5.calculate_max_chunk_size # ceil(5/2) = 3
    
    generator6 = AnkiCloze::Generator.new("one two three four five six")
    assert_equal 3, generator6.calculate_max_chunk_size # ceil(6/2) = 3
  end

  # T025: Test 3-word sentence
  def test_three_word_sentence_generates_correct_clozes
    generator = AnkiCloze::Generator.new("foo bar baz")
    result = generator.generate
    
    # max_chunk_size = ceil(3/2) = 2
    # N=1: 3 lines, N=2: 2 lines (single-chunk arrangements at offsets 0 and 1)
    assert_equal 5, result.length
    
    n1_lines = result.select { |line| line.scan(/\{\{c1::/).count == 1 }
    assert_equal 5, n1_lines.count # All are single-cloze lines
  end

  # T026: Test 5-word sentence
  def test_five_word_sentence_generates_correct_clozes
    generator = AnkiCloze::Generator.new("one two three four five")
    result = generator.generate

    # N=1: 5 lines, N=2: 2 lines, N=3: 3 lines = 10 total
    assert_equal 10, result.length

    # Count arrangements by number of cloze markers
    single_cloze_lines = result.select { |line| line.scan(/\{\{c\d+::/).count == 1 }
    double_cloze_lines = result.select { |line| line.scan(/\{\{c\d+::/).count == 2 }

    # For simplicity, just verify we have single-cloze lines (from N=1 and N=3)
    # and multi-cloze lines (from N=2)
    assert_operator single_cloze_lines.count, :>=, 5  # At least 5 from N=1, plus N=3 single-chunk
    assert_equal 2, double_cloze_lines.count # Exactly 2 from N=2
  end

  # T027: Test 6-word sentence max_chunk_size
  def test_six_word_sentence_max_chunk_size
    generator = AnkiCloze::Generator.new("a b c d e f")
    assert_equal 3, generator.calculate_max_chunk_size # ceil(6/2) = 3
  end

  # T028: Test 1-word sentence edge case
  def test_one_word_sentence
    generator = AnkiCloze::Generator.new("word")
    result = generator.generate
    
    # Should only have N=1 with 1 line
    assert_equal 1, result.length
    assert_equal "{{c1::word}}", result.first
  end

  # T029: Test 2-word sentence edge case
  def test_two_word_sentence
    generator = AnkiCloze::Generator.new("hello world")
    result = generator.generate
    
    # max_chunk_size = ceil(2/2) = 1, so only N=1
    # N=1: 2 lines
    assert_equal 2, result.length
    assert_includes result, "{{c1::hello}} world"
    assert_includes result, "hello {{c1::world}}"
  end

  # T037: Test comma preservation
  def test_comma_preservation
    generator = AnkiCloze::Generator.new("First, we analyze")
    result = generator.generate
    
    # Verify comma stays within cloze chunk
    assert_includes result, "{{c1::First,}} we analyze"
    assert_includes result, "First, {{c1::we}} analyze"
  end
end
