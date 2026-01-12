# frozen_string_literal: true

require_relative "test_helper"

class GeneratorTest < Minitest::Test
  # T011: Contract test for single-word cloze generation (N=1)
  def test_generates_single_word_clozes_for_four_word_sentence
    generator = AnkiCloze::Generator.new("The quick brown fox")
    result = generator.generate

    # Should produce 1 line for N=1 with all 4 words as separate clozes
    n1_lines = result.select { |line| line.scan(/\{\{c\d+::/).count == 4 }
    assert_equal 1, n1_lines.count

    # Verify all words are cloze'd on one line
    assert_includes result, "{{c1::The}} {{c2::quick}} {{c3::brown}} {{c4::fox}}"
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
    # N=1: 1 line with 3 clozes, N=2: 2 lines (single-chunk arrangements at offsets 0 and 1)
    assert_equal 3, result.length
    
    # Check N=1 line has 3 cloze markers
    n1_lines = result.select { |line| line.scan(/\{\{c\d+::/).count == 3 }
    assert_equal 1, n1_lines.count
  end

  # T026: Test 5-word sentence
  def test_five_word_sentence_generates_correct_clozes
    generator = AnkiCloze::Generator.new("one two three four five")
    result = generator.generate

    # N=1: 1 line with 5 clozes, N=2: 2 lines, N=3: 3 lines = 6 total
    assert_equal 6, result.length

    # Count arrangements by number of cloze markers
    five_cloze_lines = result.select { |line| line.scan(/\{\{c\d+::/).count == 5 }
    double_cloze_lines = result.select { |line| line.scan(/\{\{c\d+::/).count == 2 }
    single_cloze_lines = result.select { |line| line.scan(/\{\{c\d+::/).count == 1 }

    assert_equal 1, five_cloze_lines.count # N=1 line
    assert_equal 2, double_cloze_lines.count # N=2 has 2 arrangements
    assert_equal 3, single_cloze_lines.count # N=3 has 3 arrangements (single-chunk each)
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
    # N=1: 1 line with 2 clozes
    assert_equal 1, result.length
    assert_includes result, "{{c1::hello}} {{c2::world}}"
  end

  # T037: Test comma preservation
  def test_comma_preservation
    generator = AnkiCloze::Generator.new("First, we analyze")
    result = generator.generate
    
    # Verify comma stays within cloze chunk
    assert_includes result, "{{c1::First,}} {{c2::we}} {{c3::analyze}}"
  end

  def test_minimum_chunk_size_filters_results
    generator = AnkiCloze::Generator.new("one two three four", min_chunk_size: 2)
    result = generator.generate
    
    # Should only include N=2, not N=1
    # All results should have 2 cloze markers
    result.each do |line|
      assert_equal 2, line.scan(/\{\{c\d+::/).count
    end
    
    # Should have the N=2 arrangement
    assert_includes result, "{{c1::one two}} {{c2::three four}}"
  end

  def test_minimum_chunk_size_larger_than_max_returns_empty
    generator = AnkiCloze::Generator.new("one two three", min_chunk_size: 10)
    result = generator.generate
    
    # Max chunk size is 2, minimum is 10, so no results
    assert_empty result
  end

  def test_minimum_chunk_size_equal_to_max
    generator = AnkiCloze::Generator.new("one two three", min_chunk_size: 2)
    result = generator.generate
    
    # Should only include N=2
    assert_equal 2, result.length
    assert_includes result, "{{c1::one two}} three"
    assert_includes result, "one {{c1::two three}}"
  end

  def test_default_minimum_chunk_size_is_one
    generator1 = AnkiCloze::Generator.new("one two three")
    generator2 = AnkiCloze::Generator.new("one two three", min_chunk_size: 1)
    
    # Both should produce identical results
    assert_equal generator1.generate, generator2.generate
  end

  def test_maximum_chunk_size_filters_results
    generator = AnkiCloze::Generator.new("one two three four", max_chunk_size: 1)
    result = generator.generate
    
    # Should only include N=1, not N=2
    # Should have 1 line with 4 cloze markers
    assert_equal 1, result.length
    assert_equal 4, result.first.scan(/\{\{c\d+::/).count
    assert_includes result, "{{c1::one}} {{c2::two}} {{c3::three}} {{c4::four}}"
  end

  def test_maximum_chunk_size_smaller_than_calculated_max
    generator = AnkiCloze::Generator.new("a b c d e f", max_chunk_size: 2)
    result = generator.generate
    
    # Calculated max would be 3, but user max is 2
    # Should include N=1 (1 line with 6 clozes) and N=2 (2 lines)
    assert_equal 3, result.length
    
    # Check we have one line with 6 clozes (N=1) and two lines with fewer (N=2)
    six_cloze_lines = result.select { |line| line.scan(/\{\{c\d+::/).count == 6 }
    assert_equal 1, six_cloze_lines.count
  end

  def test_maximum_chunk_size_larger_than_calculated_max
    generator = AnkiCloze::Generator.new("one two three", max_chunk_size: 10)
    result = generator.generate
    
    # Calculated max is 2, user max is 10, so should use 2
    # Should include N=1 (1 line with 3 clozes) and N=2 (2 lines)
    assert_equal 3, result.length
  end

  def test_minimum_and_maximum_together
    generator = AnkiCloze::Generator.new("one two three four", min_chunk_size: 2, max_chunk_size: 2)
    result = generator.generate
    
    # Should only include N=2
    assert_equal 1, result.length
    assert_includes result, "{{c1::one two}} {{c2::three four}}"
  end

  def test_maximum_less_than_minimum_returns_empty
    generator = AnkiCloze::Generator.new("one two three four", min_chunk_size: 3, max_chunk_size: 2)
    result = generator.generate
    
    # Min > Max, should return empty
    assert_empty result
  end

  def test_default_maximum_chunk_size_is_nil
    generator1 = AnkiCloze::Generator.new("one two three")
    generator2 = AnkiCloze::Generator.new("one two three", max_chunk_size: nil)
    
    # Both should produce identical results
    assert_equal generator1.generate, generator2.generate
  end
end
