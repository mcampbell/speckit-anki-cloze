# frozen_string_literal: true

require_relative "test_helper"

class IntegrationTest < Minitest::Test
  # T013: Integration test for complete cloze set generation
  def test_complete_cloze_set_for_the_quick_brown_fox
    generator = AnkiCloze::Generator.new("The quick brown fox")
    result = generator.generate
    
    # Should produce 5 total lines: 4 for N=1 + 1 for N=2
    assert_equal 5, result.length
    
    # N=1 lines (4 total)
    assert_includes result, "{{c1::The}} quick brown fox"
    assert_includes result, "The {{c1::quick}} brown fox"
    assert_includes result, "The quick {{c1::brown}} fox"
    assert_includes result, "The quick brown {{c1::fox}}"
    
    # N=2 lines (1 total)
    assert_includes result, "{{c1::The quick}} {{c1::brown fox}}"
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
    assert result.any? { |line| line.include?("{{c1::It's}}") || line.include?("{{c1::It's a}}") }
    assert result.any? { |line| line.include?("{{c1::well-known}}") || line.include?("{{c1::well-known fact,}}") }
    assert result.any? { |line| line.include?("{{c1::fact,}}") || line.include?("{{c1::fact, honestly}}") }
  end
end
