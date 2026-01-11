# frozen_string_literal: true

require "test_helper"
require "open3"

class AnkiClozeTest < Minitest::Test
  # T006: Unit test for word-to-cloze transformation
  def test_format_cloze_item
    assert_equal "{{c1::hello}}", AnkiCloze.format_cloze_item("hello", 1)
    assert_equal "{{c5::world}}", AnkiCloze.format_cloze_item("world", 5)
  end

  # T007: Unit test for sentence-to-cloze conversion
  def test_convert_sentence
    input = "A fool and his money"
    expected = "{{c1::A}} {{c2::fool}} {{c3::and}} {{c4::his}} {{c5::money}}"
    assert_equal expected, AnkiCloze.convert(input)
  end

  def test_convert_single_word
    assert_equal "{{c1::Hello}}", AnkiCloze.convert("Hello")
  end

  def test_convert_two_words
    assert_equal "{{c1::Hello}} {{c2::world}}", AnkiCloze.convert("Hello world")
  end

  # T008: Unit test for empty input handling
  def test_convert_empty_string
    assert_equal "", AnkiCloze.convert("")
  end

  def test_convert_whitespace_only
    assert_equal "", AnkiCloze.convert("   ")
  end

  # T009: Integration test for CLI with ARGV input
  def test_cli_with_argv
    output, status = Open3.capture2("./bin/anki-cloze", "Hello world")
    assert_equal 0, status.exitstatus
    assert_equal "{{c1::Hello}} {{c2::world}}\n", output
  end

  def test_cli_with_argv_full_sentence
    output, status = Open3.capture2("./bin/anki-cloze", "A fool and his money")
    assert_equal 0, status.exitstatus
    assert_equal "{{c1::A}} {{c2::fool}} {{c3::and}} {{c4::his}} {{c5::money}}\n", output
  end

  def test_cli_with_empty_argv
    output, status = Open3.capture2("./bin/anki-cloze", "")
    assert_equal 0, status.exitstatus
    assert_equal "\n", output
  end

  # T010: Integration test for CLI with stdin input
  def test_cli_with_stdin
    output, status = Open3.capture2("./bin/anki-cloze", stdin_data: "Hello world")
    assert_equal 0, status.exitstatus
    assert_equal "{{c1::Hello}} {{c2::world}}\n", output
  end

  def test_cli_with_stdin_and_newline
    output, status = Open3.capture2("./bin/anki-cloze", stdin_data: "Test input\n")
    assert_equal 0, status.exitstatus
    assert_equal "{{c1::Test}} {{c2::input}}\n", output
  end
end
