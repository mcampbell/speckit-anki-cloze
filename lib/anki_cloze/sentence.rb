# frozen_string_literal: true

module AnkiCloze
  # Represents a sentence to be processed for cloze generation
  class Sentence
    # @return [String] the original sentence text
    attr_reader :text
    
    # @return [Array<String>] the words parsed from the sentence
    attr_reader :words

    # Creates a new Sentence instance
    # @param text [String] the sentence text to process
    # @raise [ArgumentError] if text is nil or empty
    def initialize(text)
      @text = text
      validate_input!
      @words = parse_words
    end

    # Returns the number of words in the sentence
    # @return [Integer] the word count
    def word_count
      @words.length
    end

    private

    # Validates that the input text is not nil or empty
    # @raise [ArgumentError] if text is nil or empty
    # @return [void]
    def validate_input!
      raise ArgumentError, "Input sentence cannot be empty" if @text.nil? || @text.strip.empty?
    end

    # Parses the text into individual words
    # @return [Array<String>] array of words
    def parse_words
      # Split on whitespace, treating contractions and hyphens as single words
      @text.strip.split(/\s+/)
    end
  end
end
