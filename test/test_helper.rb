# frozen_string_literal: true

require "minitest/autorun"

# Add lib directory to load path
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

# Load the anki_cloze module and its components
require "anki_cloze/sentence"
require "anki_cloze/chunk"
require "anki_cloze/arrangement"
require "anki_cloze/cloze_set"
require "anki_cloze/formatter"
require "anki_cloze/generator"
