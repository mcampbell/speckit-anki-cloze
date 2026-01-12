# frozen_string_literal: true

module AnkiCloze
  # Represents a specific pattern of non-overlapping chunks
  class Arrangement
    # @return [Sentence] the sentence this arrangement is for
    attr_reader :sentence
    
    # @return [Array<Chunk>] the non-overlapping chunks in this arrangement
    attr_reader :chunks

    # Creates a new Arrangement instance
    # @param sentence [Sentence] the sentence this arrangement is for
    # @param chunks [Array<Chunk>] the non-overlapping chunks in this arrangement
    # @raise [ArgumentError] if chunks overlap
    def initialize(sentence:, chunks:)
      @sentence = sentence
      @chunks = chunks
      validate_non_overlapping!
    end

    # Converts this arrangement to Anki cloze deletion format
    # @return [String] the formatted Anki cloze string
    def to_anki_format
      Formatter.to_anki_format(self)
    end

    private

    # Validates that chunks are non-overlapping
    # @raise [ArgumentError] if chunks overlap
    # @return [void]
    def validate_non_overlapping!
      return if @chunks.empty?

      # Check that chunks are sorted and don't overlap
      @chunks.each_cons(2) do |chunk1, chunk2|
        if chunk1.end_index >= chunk2.start_index
          raise ArgumentError, "Chunks must not overlap"
        end
      end
    end
  end
end
