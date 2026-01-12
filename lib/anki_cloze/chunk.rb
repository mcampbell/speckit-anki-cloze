# frozen_string_literal: true

module AnkiCloze
  # Represents a contiguous sequence of N consecutive words
  class Chunk
    # @return [Integer] the starting index in the sentence (0-based)
    attr_reader :start_index
    
    # @return [Integer] the number of words in this chunk
    attr_reader :size
    
    # @return [Array<String>] the words that make up this chunk
    attr_reader :words

    # Creates a new Chunk instance
    # @param start_index [Integer] the starting index in the sentence (0-based)
    # @param size [Integer] the number of words in this chunk
    # @param words [Array<String>] the words that make up this chunk
    def initialize(start_index:, size:, words:)
      @start_index = start_index
      @size = size
      @words = words
    end

    # Returns the chunk as a space-separated string
    # @return [String] the words joined by spaces
    def to_s
      @words.join(" ")
    end

    # Returns the ending index of this chunk in the sentence
    # @return [Integer] the ending index (0-based)
    def end_index
      @start_index + @size - 1
    end
  end
end
