# frozen_string_literal: true

module AnkiCloze
  # Represents a sentence to be processed for cloze generation
  class Sentence
    attr_reader :text, :words

    def initialize(text)
      @text = text
      validate_input!
      @words = parse_words
    end

    def word_count
      @words.length
    end

    private

    def validate_input!
      raise ArgumentError, "Input sentence cannot be empty" if @text.nil? || @text.strip.empty?
    end

    def parse_words
      # Split on whitespace, treating contractions and hyphens as single words
      @text.strip.split(/\s+/)
    end
  end
end
