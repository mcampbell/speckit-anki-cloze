# frozen_string_literal: true

require_relative "test_helper"

class IntegrationTest < Minitest::Test
  # T013: Integration test for complete cloze set generation
  def test_complete_cloze_set_for_the_quick_brown_fox
    generator = AnkiCloze::Generator.new("The quick brown fox")
    result = generator.generate
    
    # Should produce 2 total lines: 1 for N=1 + 1 for N=2
    assert_equal 2, result.length
    
    # N=1 line (all 4 words as separate clozes)
    assert_includes result, "{{c1::The}} {{c2::quick}} {{c3::brown}} {{c4::fox}}"
    
    # N=2 lines (1 total, with incrementing cloze numbers)
    assert_includes result, "{{c1::The quick}} {{c2::brown fox}}"
  end

  # T038: Test multiple punctuation types
  def test_multiple_punctuation_types
    generator = AnkiCloze::Generator.new("It's a well-known fact, honestly")
    result = generator.generate
    
    # Should handle contractions, hyphens, and commas
    assert result.any? { |line| line.include?("It's") }
    assert result.any? { |line| line.include?("well-known") }
    assert result.any? { |line| line.include?("fact,") }
    
    # Verify punctuation stays within cloze chunks
    # For N=1, all words should be in one line
    assert result.any? { |line| line.include?("{{c1::It's}}") && line.include?("{{c2::a}}") }
    assert result.any? { |line| line.include?("{{c3::well-known}}") }
    assert result.any? { |line| line.include?("{{c4::fact,}}") }
  end
end
