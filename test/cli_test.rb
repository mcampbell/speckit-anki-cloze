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
end
