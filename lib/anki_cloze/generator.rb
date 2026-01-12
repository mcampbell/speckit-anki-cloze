# frozen_string_literal: true

module AnkiCloze
  # Main generator for creating cloze deletions
  class Generator
    # @return [Sentence] the sentence being processed
    attr_reader :sentence

    # Creates a new Generator instance
    # @param sentence_text [String] the sentence text to process
    # @param min_chunk_size [Integer] minimum chunk size to generate (default: 1)
    # @param max_chunk_size [Integer, nil] maximum chunk size to generate (default: nil, uses calculated max)
    # @raise [ArgumentError] if sentence_text is invalid
    def initialize(sentence_text, min_chunk_size: 1, max_chunk_size: nil)
      @sentence = Sentence.new(sentence_text)
      @min_chunk_size = min_chunk_size
      @max_chunk_size = max_chunk_size
    end

    # Generate all cloze sets for N from min to max chunk size
    # @return [Array<String>] array of formatted Anki cloze strings
    def generate
      results = []
      max_n = calculate_max_chunk_size
      
      # Apply user-specified maximum if provided
      max_n = [@max_chunk_size, max_n].min if @max_chunk_size
      
      min_n = [@min_chunk_size, 1].max

      # If minimum is greater than maximum, return empty results
      return results if min_n > max_n

      (min_n..max_n).each do |n|
        cloze_set = ClozeSet.new(@sentence, n)
        cloze_set.generate_arrangements

        # Convert each arrangement to Anki format
        cloze_set.arrangements.each do |arrangement|
          results << arrangement.to_anki_format
        end
      end

      results
    end

    # Calculate max chunk size using ceil(word_count/2) formula
    # @return [Integer] the maximum chunk size
    def calculate_max_chunk_size
      (@sentence.word_count / 2.0).ceil
    end
  end
end
