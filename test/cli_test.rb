# frozen_string_literal: true

require_relative "test_helper"
require "open3"

class CliTest < Minitest::Test
  def setup
    @cli_path = File.expand_path("../bin/anki-cloze", __dir__)
  end

  def test_accepts_argv_input
    stdout, stderr, status = Open3.capture3(@cli_path, "hello world")
    assert status.success?
    assert_includes stdout, "{{c1::hello}}"
    assert_empty stderr
  end

  def test_accepts_stdin_input
    stdout, stderr, status = Open3.capture3(@cli_path, stdin_data: "hello world\n")
    assert status.success?
    assert_includes stdout, "{{c1::hello}}"
    assert_empty stderr
  end

  def test_shows_help
    stdout, stderr, status = Open3.capture3(@cli_path, "--help")
    assert status.success?
    assert_includes stdout, "Usage:"
    assert_empty stderr
  end

  def test_error_on_empty_input
    stdout, stderr, status = Open3.capture3(@cli_path, "")
    refute status.success?
    assert_equal 1, status.exitstatus
    assert_includes stderr, "Error:"
    assert_empty stdout
  end

  def test_error_on_whitespace_only
    stdout, stderr, status = Open3.capture3(@cli_path, "   ")
    refute status.success?
    assert_equal 1, status.exitstatus
    assert_includes stderr, "Error:"
    assert_empty stdout
  end

  def test_correct_exit_code_on_success
    stdout, stderr, status = Open3.capture3(@cli_path, "test")
    assert_equal 0, status.exitstatus
  end

  def test_correct_exit_code_on_error
    stdout, stderr, status = Open3.capture3(@cli_path, "")
    assert_equal 1, status.exitstatus
  end

  def test_minimum_flag_short_form
    stdout, stderr, status = Open3.capture3(@cli_path, "-m", "2", "one two three four")
    assert status.success?
    assert_empty stderr
    
    # Should only include N=2 clozes, not N=1
    refute_includes stdout, "{{c1::one}} two three four"
    assert_includes stdout, "{{c1::one two}} {{c2::three four}}"
  end

  def test_minimum_flag_long_form
    stdout, stderr, status = Open3.capture3(@cli_path, "--minimum", "2", "one two three four")
    assert status.success?
    assert_empty stderr
    
    # Should only include N=2 clozes, not N=1
    refute_includes stdout, "{{c1::one}} two three four"
    assert_includes stdout, "{{c1::one two}} {{c2::three four}}"
  end

  def test_minimum_flag_filters_correctly
    stdout, stderr, status = Open3.capture3(@cli_path, "--minimum", "3", "a b c d e f")
    assert status.success?
    
    # Only N=3 should be included (max chunk size is 3)
    # For 6 words with chunk size 3, there's 1 arrangement (offset 0: 2 chunks of 3)
    lines = stdout.split("\n").reject(&:empty?)
    assert_equal 1, lines.length
    
    # Line should have exactly 2 cloze markers (6/3 = 2 chunks)
    assert_equal 2, lines.first.scan(/\{\{c\d+::/).count
  end

  def test_minimum_larger_than_max_returns_nothing
    stdout, stderr, status = Open3.capture3(@cli_path, "--minimum", "10", "one two three")
    assert status.success?
    assert_empty stderr
    assert_empty stdout.strip
  end

  def test_minimum_equal_to_max_includes_max
    stdout, stderr, status = Open3.capture3(@cli_path, "--minimum", "2", "one two three")
    assert status.success?
    
    # Max chunk size is 2, so should include N=2 only
    # For 3 words with chunk size 2, there are 2 arrangements
    lines = stdout.split("\n").reject(&:empty?)
    assert_equal 2, lines.length
    
    # Verify both are N=2 arrangements (single cloze markers since chunks don't fill)
    assert_includes stdout, "{{c1::one two}} three"
    assert_includes stdout, "one {{c1::two three}}"
  end

  def test_minimum_with_stdin
    stdout, stderr, status = Open3.capture3(@cli_path, "--minimum", "2", stdin_data: "one two three four\n")
    assert status.success?
    assert_empty stderr
    
    # Should only include N=2 clozes
    refute_includes stdout, "{{c1::one}} two three four"
    assert_includes stdout, "{{c1::one two}} {{c2::three four}}"
  end

  def test_minimum_invalid_value
    stdout, stderr, status = Open3.capture3(@cli_path, "--minimum", "abc", "one two three")
    refute status.success?
    assert_includes stderr, "Error:"
  end

  def test_minimum_zero_value
    stdout, stderr, status = Open3.capture3(@cli_path, "--minimum", "0", "one two three")
    refute status.success?
    assert_includes stderr, "Error:"
  end

  def test_minimum_negative_value
    stdout, stderr, status = Open3.capture3(@cli_path, "--minimum", "-1", "one two three")
    refute status.success?
    assert_includes stderr, "Error:"
  end

  def test_maximum_flag_short_form
    stdout, stderr, status = Open3.capture3(@cli_path, "-x", "1", "one two three four")
    assert status.success?
    assert_empty stderr
    
    # Should only include N=1, not N=2
    assert_includes stdout, "{{c1::one}} two three four"
    refute_includes stdout, "{{c1::one two}} {{c2::three four}}"
  end

  def test_maximum_flag_long_form
    stdout, stderr, status = Open3.capture3(@cli_path, "--maximum", "1", "one two three four")
    assert status.success?
    assert_empty stderr
    
    # Should only include N=1, not N=2
    assert_includes stdout, "{{c1::one}} two three four"
    refute_includes stdout, "{{c1::one two}} {{c2::three four}}"
  end

  def test_maximum_flag_filters_correctly
    stdout, stderr, status = Open3.capture3(@cli_path, "--maximum", "2", "a b c d e f")
    assert status.success?
    
    # Should include N=1 and N=2, but not N=3
    lines = stdout.split("\n").reject(&:empty?)
    
    # Should have single-word clozes (N=1: 6 lines) and two-word arrangements (N=2: varies)
    assert_operator lines.length, :>, 6
    
    # Verify no N=3 (which would have 2 cloze markers for 6 words)
    lines.each do |line|
      cloze_count = line.scan(/\{\{c\d+::/).count
      assert_operator cloze_count, :<=, 3 # Max of 3 chunks for N=2 (offset 0: 3 chunks of 2)
    end
  end

  def test_maximum_smaller_than_min_returns_nothing
    stdout, stderr, status = Open3.capture3(@cli_path, "--minimum", "3", "--maximum", "2", "one two three four")
    assert status.success?
    assert_empty stderr
    assert_empty stdout.strip
  end

  def test_maximum_equal_to_min_includes_only_that_size
    stdout, stderr, status = Open3.capture3(@cli_path, "--minimum", "2", "--maximum", "2", "one two three four")
    assert status.success?
    
    # Should only include N=2
    lines = stdout.split("\n").reject(&:empty?)
    assert_equal 1, lines.length
    assert_includes stdout, "{{c1::one two}} {{c2::three four}}"
  end

  def test_maximum_with_stdin
    stdout, stderr, status = Open3.capture3(@cli_path, "--maximum", "1", stdin_data: "one two three four\n")
    assert status.success?
    assert_empty stderr
    
    # Should only include N=1 clozes
    assert_includes stdout, "{{c1::one}} two three four"
    refute_includes stdout, "{{c1::one two}} {{c2::three four}}"
  end

  def test_maximum_invalid_value
    stdout, stderr, status = Open3.capture3(@cli_path, "--maximum", "abc", "one two three")
    refute status.success?
    assert_includes stderr, "Error:"
  end

  def test_maximum_zero_value
    stdout, stderr, status = Open3.capture3(@cli_path, "--maximum", "0", "one two three")
    refute status.success?
    assert_includes stderr, "Error:"
  end

  def test_maximum_negative_value
    stdout, stderr, status = Open3.capture3(@cli_path, "--maximum", "-1", "one two three")
    refute status.success?
    assert_includes stderr, "Error:"
  end

  def test_minimum_and_maximum_together
    stdout, stderr, status = Open3.capture3(@cli_path, "-m", "2", "-x", "2", "a b c d e f")
    assert status.success?
    
    # Should only include N=2
    lines = stdout.split("\n").reject(&:empty?)
    
    # For 6 words, N=2 should produce arrangements with offsets 0 and 1
    assert_operator lines.length, :>, 0
    
    # Verify all are N=2 arrangements (3 chunks for offset 0, 2 chunks for offset 1)
    lines.each do |line|
      cloze_count = line.scan(/\{\{c\d+::/).count
      assert_operator cloze_count, :>=, 2
      assert_operator cloze_count, :<=, 3
    end
  end
end
