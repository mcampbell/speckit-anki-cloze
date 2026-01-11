# frozen_string_literal: true

module AnkiCloze
  # Represents a contiguous sequence of N consecutive words
  class Chunk
    attr_reader :start_index, :size, :words

    def initialize(start_index:, size:, words:)
      @start_index = start_index
      @size = size
      @words = words
    end

    def to_s
      @words.join(" ")
    end

    def end_index
      @start_index + @size - 1
    end
  end
end
